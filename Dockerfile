FROM alpine
MAINTAINER Abe Masahiro <pen@thcomp.org>

RUN apk add -q --no-cache \
            git      \
            nginx    \
            php5-fpm

RUN apk add -q --no-cache \
            php5-curl    \
            php5-json    \
            php5-openssl \
            php5-phar    \
            php5-zlib

RUN rm -r /var/www \
 && git clone -q git://github.com/killer4989/p2-php.git /var/www

WORKDIR /var/www
RUN wget -q http://getcomposer.org/composer.phar
RUN php composer.phar config -g repos.packagist composer https://packagist.jp
RUN php composer.phar global require hirak/prestissimo
RUN php composer.phar install
RUN rm -r composer.* ~/.composer `find . -name '.git'`

RUN apk add -q --no-cache \
            php5-dom \
            php5-pdo_sqlite

RUN apk del -q \
            git \
            php5-phar

COPY rootfs /

CMD ["/etc/rc.entry"]
