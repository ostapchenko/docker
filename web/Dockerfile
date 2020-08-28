# Use the official Ubuntu image as a parent image.
FROM ubuntu:20.04

# image labels:
LABEL maintainer="ostapchenko.a@gmail.com"
LABEL version="1.0"
LABEL description="WEB image for running PHP applications."

# build arguments:
ARG TZ=America/New_York
ARG PHP_VERSION=7.4
ARG DEBIAN_FRONTEND=noninteractive

# env parameters:
ENV PHP_MEMORY_LIMIT=256M \
    PHP_UPLOAD_MAX_FILESIZE=128M \
    PHP_POST_MAX_SIZE=64M \
    PHP_DISPLAY_ERRORS=1 \
    PHP_ERROR_REPORTING=32767 \
    COMPOSER_ALLOW_SUPERUSER=1

# env init parameters (Timezone, locale):
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get -y update \
    && apt-get install -y locales \
    && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A \
        /usr/share/locale/locale.alias en_US.UTF-8
ENV LANG=en_US.utf8

# install main packages (apache, php etc.)
RUN apt-get -y update \
    && apt-get install -y \
        software-properties-common \
        apt-transport-https \
        ca-certificates
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php
RUN apt-get -y update \
    && apt-get -y install \
        nano \
        curl \
        git \
        apache2 \
        libapache2-mod-php$PHP_VERSION

# apache settings:
RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf \
    && a2enmod rewrite \
    && a2enmod ssl \
    && sed -i \
         's/ErrorLog \${APACHE_LOG_DIR}\/error\.log/ErrorLog \/dev\/stderr/' \
         /etc/apache2/apache2.conf \
        && echo "CustomLog /dev/stdout combined" >> /etc/apache2/apache2.conf

# php extensions:
RUN apt-get -y update \
    && apt-get install -y \
    php$PHP_VERSION-zip \
    php$PHP_VERSION-curl \
    php$PHP_VERSION-pdo \
    php$PHP_VERSION-xml \
    php$PHP_VERSION-json \
    php$PHP_VERSION-gmp \
    php$PHP_VERSION-bcmath \
    php$PHP_VERSION-mbstring \
    php$PHP_VERSION-apcu \
    php$PHP_VERSION-gd \
    php$PHP_VERSION-mysql \
    php$PHP_VERSION-redis

# php settings:
RUN echo \
"; settings customization from env\
; priority=50\
error_reporting = \${PHP_ERROR_REPORTING}\
display_errors = \${PHP_DISPLAY_ERRORS}\
memory_limit = \${PHP_MEMORY_LIMIT}\
upload_max_filesize = \${PHP_UPLOAD_MAX_FILESIZE}\
max_post_size = \${PHP_POST_MAX_SIZE}\
date.timezone = \${TZ}\
" > /etc/php/$PHP_VERSION/mods-available/custom.ini \
    && phpenmod -v $PHP_VERSION custom

# get composer:
RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# listens to ports:
EXPOSE 80 443

# data volumes to be mounted to the container:
VOLUME ["/var/www", "/etc/apache/sites-enabled"]

# copy ssl certificates:
COPY localhost.crt /localhost.crt
COPY localhost.key /localhost.key

# copy script into container
COPY run.sh /run.sh

# container execution command:
CMD ["/run.sh"]
