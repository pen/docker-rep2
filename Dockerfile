FROM alpine
MAINTAINER Abe Masahiro <pen@thcomp.org>

RUN apk add -U --virtual .builders \
            curl \
            git \
            php7-phar

RUN apk add \
            nginx \
            php7-curl \
            php7-dom \
            php7-fpm \
            php7-json \
            php7-mbstring \
            php7-openssl \
            php7-pdo_sqlite \
            php7-session \
            php7-simplexml \
            php7-zlib

RUN rm -r /var/www \
 && git clone git://github.com/killer4989/p2-php.git /var/www

WORKDIR /var/www
RUN curl -o composer https://getcomposer.org/composer.phar \
 && php7 composer config -g repos.packagist composer https://packagist.jp \
 && php7 composer global require hirak/prestissimo \
 && php7 composer install

RUN apk del --purge .builders \
 && rm -r /var/cache/apk/* \
          ~/.composer \
          composer* \
          `find . -name '.git*'`

COPY rootfs /

VOLUME /ext
EXPOSE 80

CMD ["/etc/rc.entry"]
