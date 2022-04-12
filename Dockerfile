ARG PHP_VERSION="8.1.2"
ARG ALPINE_VERSION="3.15"

FROM php:${PHP_VERSION}-cli-alpine${ALPINE_VERSION} AS builder

ARG COMPOSER_VERSION="1.10.25"
ARG GITHUB_P2_HASH="e5a5325"
ARG GITHUB_2CPX_HASH="15bf90b"

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

RUN curl -LO https://github.com/mikoim/p2-php/archive/${GITHUB_P2_HASH}.zip
RUN unzip ${GITHUB_P2_HASH}.zip
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

RUN curl -LO https://raw.githubusercontent.com/yama-natuki/2chproxy.pl/${GITHUB_2CPX_HASH}/2chproxy.pl
RUN chmod 755 2chproxy.pl
RUN patch -p1 < /tmp/2chproxy.patch
RUN mv 2chproxy.pl /usr/local/bin/


FROM php:${PHP_VERSION}-cli-alpine${ALPINE_VERSION} AS builder2

ARG PX2C_VERSION="v20220406"

RUN apk --update-cache add \
    curl-dev \
    g++ \
    gnu-libiconv-dev \
    lua5.4-dev \
    make \
    patch

WORKDIR /root
RUN wget https://notabug.org/NanashiNoGombe/proxy2ch/archive/${PX2C_VERSION}.tar.gz
RUN tar xzvf ${PX2C_VERSION}.tar.gz

WORKDIR /root/proxy2ch
COPY patch /tmp
RUN patch -p1 < /tmp/proxy2ch.patch
RUN make


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
            perl-lwp-useragent-determined \
            perl-yaml-tiny \
            zlib

COPY --from=builder /usr/local /usr/local
COPY --from=builder /var/www   /var/www
COPY rootfs /

RUN apk --no-cache add \
    libcurl \
    libstdc++ \
    lua5.4-libs

COPY --from=builder2 /root/proxy2ch/proxy2ch /usr/local/bin/

RUN apk --no-cache add runit


VOLUME /ext
EXPOSE 80

CMD ["/etc/rc.entry"]
