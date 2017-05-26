FROM alpine
MAINTAINER Abe Masahiro <pen@thcomp.org>

RUN apk add --virtual .builders \
            git \
            curl \
            php5-phar

RUN apk add \
            nginx \
            php5-fpm \
            php5-curl \
            php5-json \
            php5-openssl \
            php5-zlib

RUN rm -r /var/www \
 && git clone git://github.com/killer4989/p2-php.git /var/www

WORKDIR /var/www
RUN curl -o composer https://getcomposer.org/composer.phar \
 && php5 composer config -g repos.packagist composer https://packagist.jp \
 && php5 composer global require hirak/prestissimo \
 && php5 composer install \
 && rm -r composer ~/.composer `find . -name '.git*'`

RUN apk add \
            php5-dom \
            php5-pdo_sqlite

RUN apk del .builders \
 && rm -rf /var/cache/apk/*

COPY ["rootfs", "/"]

CMD ["/etc/rc.entry"]
