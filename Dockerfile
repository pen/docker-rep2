FROM ubuntu
MAINTAINER Abe Masahiro <pen@thcomp.org>

RUN apt update \
 && apt full-upgrade -y

RUN apt install -y software-properties-common \
 && add-apt-repository ppa:ondrej/php \
 && apt update

RUN apt install -y \
                php8.0-cgi \
                php8.0-curl \
                php8.0-gd \
                php8.0-mbstring \
                php8.0-sqlite3 \
                php8.0-xml \
                php8.0-zip

RUN apt install -y \
                libhttp-daemon-perl \
                libwww-perl \
                libyaml-tiny-perl

RUN apt install -y \
                cron \
                git \
                h2o \
                sqlite3 \
                sudo

COPY rootfs /

WORKDIR /root

RUN php -r "readfile('https://getcomposer.org/installer');" | php -- --version 1.10.17 \
 && ./composer.phar config -g repos.packagist composer https://packagist.jp

RUN git clone --depth 1 git://github.com/yama-natuki/2chproxy.pl.git 2chpx \
 && mv 2chpx/2chproxy.pl /usr/local/bin/

RUN git clone -b php8-merge --depth 1 git://github.com/mikoim/p2-php.git

RUN cd p2-php \
 && /root/composer.phar install

RUN patch -p1 < p2-php.patch \
 && cd p2-php \
 && rm -r composer* `find . -name '.git*'` \
 && mkdir data/image_cache \
 && mv data .data/ \
 && ln -s /ext/data \
 && ln -s /ext/data/image_cache rep2/ic \
 && cd .. \
 && rm -rf /var/www \
 && mv p2-php /var/www

RUN rm -r *.patch 2chpx composer.phar .composer

VOLUME /ext
EXPOSE 80

CMD ["/etc/rc.entry"]
