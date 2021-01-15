FROM php:cli-alpine
MAINTAINER Abe Masahiro <pen@thcomp.org>

RUN apk add -U --virtual .builders \
            git \
            patch \
            gettext-dev \
            jpeg-dev \
            libpng-dev \
            zlib-dev

RUN apk add \
            h2o \
            sudo \
            gettext \
            libintl \
            libjpeg \
            libpng \
            perl-lwp-useragent-determined \
            perl-yaml-tiny \
            zlib

RUN docker-php-ext-configure \
            gd --with-jpeg \
 \
 && docker-php-ext-install -j$(nproc) \
            gd \
            gettext

RUN curl https://getcomposer.org/installer \
        | php -- --version 1.10.17 --install-dir /root \
 \
 && /root/composer.phar config -g repos.packagist composer https://packagist.jp \
 && /root/composer.phar global require hirak/prestissimo

RUN cd /var \
 && curl -L -o www/p2-php.zip \
        https://github.com/mikoim/p2-php/archive/13fced3.zip \
 \
 && unzip www/p2-php.zip \
 && mv www www.orig \
 && mv p2-php-* www \
 \
 && cd www \
 && /root/composer.phar install

RUN curl -o /usr/local/bin/2chproxy.pl \
        https://raw.githubusercontent.com/yama-natuki/2chproxy.pl/8260ca5/2chproxy.pl \
 && chmod 755 /usr/local/bin/2chproxy.pl

COPY rootfs /

RUN cd /var/www \
 && patch -p1 < /root/p2-php.patch \
 \
 && mv conf conf.orig && ln -s /ext/conf conf \
 && mv data data.orig && ln -s /ext/data data \
 && ln -s /ext/rep2/ic rep2/ic

RUN apk del --purge .builders \
 \
 && rm -r \
        /var/cache/apk/* \
        /var/www.orig \
        /var/www/doc \
        `find /var/www -name '.git*' -o -name 'composer.*'` \
        /usr/local/include \
        /usr/local/php \
        /root/*.patch \
        /root/composer.phar \
        /root/.composer

VOLUME /ext
EXPOSE 80

CMD ["/etc/rc.entry"]
