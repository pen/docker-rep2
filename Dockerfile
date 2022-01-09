FROM php:8.0.14-cli-alpine3.15 AS builder

ARG p2_hash="673bec7"
ARG npx_hash="15bf90b"
ARG composer_version="1.10.24"

WORKDIR /tmp

RUN curl https://getcomposer.org/installer | php -- --version $composer_version
RUN ./composer.phar config -g repos.packagist composer https://packagist.jp
RUN ./composer.phar global require hirak/prestissimo

RUN curl -LO https://raw.githubusercontent.com/yama-natuki/2chproxy.pl/$npx_hash/2chproxy.pl
RUN chmod 755 2chproxy.pl
RUN mv 2chproxy.pl /usr/local/bin/

RUN curl -LO https://github.com/mikoim/p2-php/archive/$p2_hash.zip
RUN unzip $p2_hash.zip
RUN rm -rf /var/www && mv p2-php-* /var/www

RUN apk add git \
            patch \
            gettext-dev \
            jpeg-dev \
            libpng-dev \
            zlib-dev

RUN docker-php-ext-configure gd --with-jpeg
RUN docker-php-ext-install -j$(nproc) gd gettext

WORKDIR /var/www

RUN /tmp/composer.phar install
RUN rm -r doc
RUN rm -rf `find . -name '.git*' -o -name 'composer.*'`

COPY patch /tmp
RUN patch -p1 < /tmp/p2-php.patch

RUN mv conf conf.orig && ln -s /ext/conf conf
RUN mv data data.orig && ln -s /ext/data data
RUN ln -s /ext/rep2/ic rep2/ic


FROM php:8.0.14-cli-alpine3.15
LABEL org.opencontainers.image.authors="Abe Masahiro <pen@thcomp.org>" \
    org.opencontainers.image.source="https://github.com/pen/docker-rep2"

RUN apk add h2o \
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

VOLUME /ext
EXPOSE 80

CMD ["/etc/rc.entry"]
