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
            libintl \
            libjpeg \
            libpng \
            perl-lwp-useragent-determined \
            perl-yaml-tiny \
            sudo \
            zlib

RUN docker-php-ext-configure gd --with-jpeg \
 && docker-php-ext-install -j$(nproc) gettext gd

RUN curl -s -o /usr/local/bin/2chproxy.pl \
        https://raw.githubusercontent.com/yama-natuki/2chproxy.pl/master/2chproxy.pl \
 && chmod 755 /usr/local/bin/2chproxy.pl

RUN curl -s https://getcomposer.org/installer \
        | php -- --version 1.10.17 --install-dir /root \
 && /root/composer.phar config -g repos.packagist composer https://packagist.jp

RUN cd /var \
 && rm -r www \
 && git clone -b php8-merge --depth 1 git://github.com/mikoim/p2-php.git www \
 && cd www \
 && /root/composer.phar install

COPY rootfs /

RUN cd /var/www \
 && patch -p1 < /root/p2-php.patch \
 && mkdir -p conf data rep2/ic \
 && mv conf .conf \
 && ln -s /ext/conf conf \
 && mv data .data \
 && ln -s /ext/data data \
 && mv rep2/ic rep2/.ic \
 && ln -s /ext/rep2/ic rep2/ic

RUN apk del --purge .builders \
 && rm -r /var/cache/apk/* \
 && cd /root && rm -r *.patch composer.phar .composer \
 && cd /var/www && rm -r composer* `find . -name '.git*'`

VOLUME /ext
EXPOSE 80

CMD ["/etc/rc.entry"]
