FROM php:7.4-fpm

LABEL maintainer="takashiki <857995137@qq.com>"

RUN apt-get update -yqq && \
    apt-get install -y apt-utils && \
    pecl channel-update pecl.php.net

# Install base vendor extensions
RUN apt-get install -y --no-install-recommends \
    curl \
    libmemcached-dev \
    libz-dev \
    libpq-dev \
    libjpeg-dev \
    libpng-dev \
    libfreetype6-dev \
    libssl-dev \
    libmcrypt-dev \
    zlib1g-dev \
    libicu-dev \
    g++ \
    libmagickwand-dev \
    imagemagick \
    libgmp-dev

# Install base php extensions
RUN docker-php-ext-install pcntl && \
    docker-php-ext-install bcmath && \
    docker-php-ext-install exif && \
    docker-php-ext-install mysqli && \
    docker-php-ext-install tokenizer && \
    docker-php-ext-install gmp && \
    docker-php-ext-install pdo_mysql && \
    docker-php-ext-install pdo_pgsql && \
    docker-php-ext-configure intl && \
    docker-php-ext-install intl && \
    docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-jpeg-dir=/usr/lib \
        --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd

RUN pecl install -o -f redis && \
    docker-php-ext-enable redis && \
    pecl install imagick && \
    docker-php-ext-enable imagick && \ 
    pecl install swoole && \
    docker-php-ext-enable swoole

# Clean up
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    rm /var/log/lastlog /var/log/faillog

WORKDIR /var/www