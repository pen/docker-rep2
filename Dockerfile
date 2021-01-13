FROM alpine:3.7
MAINTAINER Abe Masahiro <pen@thcomp.org>

RUN apk add -U --virtual .builders \
            curl \
            git \
            php7-openssl \
            php7-simplexml

RUN apk add \
            h2o \
            mysql \
            mysql-client \
            sudo \
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
            php7-zlib

RUN mkdir /run/mysqld \
 && chown mysql:mysql /run/mysqld

RUN curl https://getcomposer.org/installer \
        | php -- --version 1.10.17 --install-dir /root \
 \
 && /root/composer.phar config -g repos.packagist composer https://packagist.jp \
 && /root/composer.phar global require hirak/prestissimo

COPY rootfs /

RUN cd /var \
 && curl -L -o www/p2-php.zip \
        https://github.com/open774/p2-php/archive/f0a58fd.zip \
 \
 && unzip www/p2-php.zip \
 && mv www www.orig \
 && mv p2-php-* www \
 \
 && cd www \
 && patch -p1 < /root/no-dropbox.patch \
 && /root/composer.phar install

RUN curl -o /usr/local/bin/2chproxy.pl \
        https://raw.githubusercontent.com/yama-natuki/2chproxy.pl/8260ca5/2chproxy.pl \
 && chmod 755 /usr/local/bin/2chproxy.pl

RUN cd /var/www \
 && patch -p1 < /root/p2-php.patch \
 && patch -p1 < /root/default-bbsmenu.patch \
 && patch -p1 < /root/re-ita_match.patch \
 \
 && mv conf conf.orig && ln -s /ext/conf conf \
 && mv data data.orig && ln -s /ext/data data \
 && mv rep2/ic rep2/ic.orig && ln -s /ext/ic/file rep2/ic

RUN apk del --purge .builders \
 \
 && rm -r \
        /var/cache/apk/* \
        /var/www.orig \
        /var/www/doc \
        `find /var/www -name '.git*' -o -name 'composer.*'` \
        /root/*.patch \
        /root/composer.phar \
        /root/.composer

VOLUME /ext
EXPOSE 80

CMD ["/etc/rc.entry"]
