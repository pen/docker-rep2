FROM alpine:3.7
MAINTAINER Abe Masahiro <pen@thcomp.org>

RUN apk add -U --virtual .builders \
            git \
            php7-openssl \
            php7-simplexml

RUN apk add \
            h2o \
            mysql \
            mysql-client \
            perl-lwp-useragent-determined \
            perl-yaml-tiny \
            php7 \
            php7-cgi \
            php7-curl \
            php7-dom \
            php7-gd \
            php7-json \
            php7-mbstring \
            php7-mysqli \
            php7-pdo_sqlite \
            php7-phar \
            php7-session \
            php7-zlib \
            sudo

RUN mkdir /run/mysqld \
 && chown mysql:mysql /run/mysqld

WORKDIR /root

RUN php -r "readfile('https://getcomposer.org/installer');" | php \
 && ./composer.phar config -g repos.packagist composer https://packagist.jp \
 && ./composer.phar global require hirak/prestissimo

RUN git clone git://github.com/open774/p2-php.git \
 && cd p2-php \
 && /root/composer.phar install

RUN git clone git://github.com/yama-natuki/2chproxy.pl.git 2chpx \
 && mv 2chpx/2chproxy.pl /usr/local/bin/

COPY rootfs /

RUN patch -p1 < p2-php.patch \
 && cd p2-php \
 && rm -r composer* `find . -name '.git*'` \
 && mkdir -p .bak/ic \
 && mv data .bak/ \
 && ln -s /ext/data \
 && mv rep2/ic .bak/ic/file \
 && ln -s /ext/ic/file rep2/ic \
 && cd .. \
 && rm -r /var/www \
 && mv p2-php /var/www

RUN apk del --purge .builders \
 && rm -r /var/cache/apk/* \
 && rm -r *.patch 2chpx composer.phar .composer

VOLUME /ext
EXPOSE 80

CMD ["/etc/rc.entry"]
