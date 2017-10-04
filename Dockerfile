FROM alpine
MAINTAINER Abe Masahiro <pen@thcomp.org>

RUN apk add -U --virtual .builders \
            curl \
            git \
            php7-phar

RUN apk add \
            mysql \
            mysql-client \
            nginx \
            perl-lwp-useragent-determined \
            perl-yaml-tiny \
            php7 \
            php7-curl \
            php7-dom \
            php7-fpm \
            php7-gd \
            php7-json \
            php7-mbstring \
            php7-mysqli \
            php7-openssl \
            php7-pdo_sqlite \
            php7-session \
            php7-simplexml \
            php7-sqlite3 \
            php7-zlib

RUN mkdir /run/mysqld \
 && chown mysql:mysql /run/mysqld

RUN cd /root \
 && curl -o composer https://getcomposer.org/composer.phar \
 && chmod 755 composer \
 && mv composer /usr/local/bin/ \
 && composer config -g repos.packagist composer https://packagist.jp \
 && composer global require hirak/prestissimo

WORKDIR /root

RUN git clone git://github.com/open774/p2-php.git \
 && cd p2-php \
 && composer install

COPY rootfs /

RUN git clone git://github.com/yama-natuki/2chproxy.pl.git 2chpx \
 && patch -p1 < 2chpx.patch \
 && mv 2chpx/2chproxy.pl /usr/local/bin/

RUN patch -p1 < p2-php.patch \
 && cd p2-php \
 && rm -r composer* `find . -name '.git*'` \
 && mkdir -p .bak/ic \
 && mv data .bak/ \
 && ln -s /ext/data \
 && mv rep2/ic .bak/ic/file \
 && ln -s /ext/ic/file rep2/ic

RUN rm -r /var/www \
 && mv p2-php /var/www

RUN apk del --purge .builders \
 && rm -r /var/cache/apk/* /usr/local/bin/composer \
 && rm -r *.patch 2chpx .composer

VOLUME /ext
EXPOSE 80

CMD ["/etc/rc.entry"]
