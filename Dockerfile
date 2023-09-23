ARG PHP_VERSION="8.1.23"
ARG ALPINE_VERSION="3.18"

FROM php:${PHP_VERSION}-cli-alpine${ALPINE_VERSION} AS builder

ARG COMPOSER_VERSION="1.10.26"
ARG GITHUB_REP2_HASH="e5a5325"
ARG GITHUB_NCPX_HASH="15bf90b"

RUN apk --update-cache add \
            git \
            patch \
            gettext-dev \
            jpeg-dev \
            libpng-dev \
            zlib-dev

RUN docker-php-ext-configure gd --with-jpeg
RUN docker-php-ext-install -j$(nproc) gd gettext

WORKDIR /tmp

RUN curl https://getcomposer.org/installer | php -- --version ${COMPOSER_VERSION}
RUN ./composer.phar config -g repos.packagist composer https://packagist.jp
RUN ./composer.phar global require hirak/prestissimo

RUN curl -LO https://github.com/mikoim/p2-php/archive/${GITHUB_REP2_HASH}.zip
RUN unzip ${GITHUB_REP2_HASH}.zip
RUN rm -rf /var/www && mv p2-php-* /var/www

WORKDIR /var/www

RUN /tmp/composer.phar install
RUN rm -r doc
RUN rm -rf `find . -name '.git*' -o -name 'composer.*'`

COPY patch /tmp
RUN patch -p1 < /tmp/p2-php.patch

RUN mv conf conf.orig && ln -s /ext/conf conf
RUN mv data data.orig && ln -s /ext/data data
RUN ln -s /ext/rep2/ic rep2/ic

RUN curl -LO https://raw.githubusercontent.com/yama-natuki/2chproxy.pl/${GITHUB_NCPX_HASH}/2chproxy.pl
RUN patch -p1 < /tmp/2chproxy.patch
RUN chmod 755 2chproxy.pl
RUN mv 2chproxy.pl /usr/local/bin/


FROM php:${PHP_VERSION}-cli-alpine${ALPINE_VERSION}
LABEL org.opencontainers.image.authors="Abe Masahiro <pen@thcomp.org>" \
    org.opencontainers.image.source="https://github.com/pen/docker-rep2"

RUN apk --no-cache add \
            h2o \
            sudo \
            gettext \
            libintl \
            libjpeg \
            libpng \
            perl-http-daemon \
            perl-lwp-useragent-determined \
            perl-yaml-tiny \
            zlib

COPY --from=builder /usr/local /usr/local
COPY --from=builder /var/www   /var/www
COPY rootfs /

VOLUME /ext
EXPOSE 80

CMD ["/etc/rc.entry"]
