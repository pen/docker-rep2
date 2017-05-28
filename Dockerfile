FROM alpine
MAINTAINER Abe Masahiro <pen@thcomp.org>

RUN apk add -U --virtual .builders \
            curl \
            git \
            php5-phar

RUN apk add \
            nginx \
            php5-curl \
            php5-dom \
            php5-fpm \
            php5-json \
            php5-openssl \
            php5-pdo_sqlite \
            php5-zlib

RUN rm -r /var/www \
 && git clone git://github.com/killer4989/p2-php.git /var/www

WORKDIR /var/www
RUN curl -o composer https://getcomposer.org/composer.phar \
 && php5 composer config -g repos.packagist composer https://packagist.jp \
 && php5 composer global require hirak/prestissimo \
 && php5 composer install

RUN apk del --purge .builders \
 && rm -r /var/cache/apk/* \
          ~/.composer \
          composer* \
          `find . -name '.git*'`

COPY rootfs /

VOLUME /ext
EXPOSE 80

CMD /etc/rc.entry
