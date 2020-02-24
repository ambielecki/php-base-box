# =============================================================================
# ambielecki/php-base-box
#
# Apache, PHP 7.3, and necessary tools for a general Laravel deploy
# Need to add local conf files, ssh-keys, etc
#
# =============================================================================

FROM php:7.3.15-apache

RUN apt-get update && \
    apt-get upgrade -y

RUN pecl install mongodb xdebug

RUN apt-get install -y --force-yes \
    cowsay \
    curl \
    fortune \
    git \
    gnupg \
    libgd-dev \
    libxml2-dev \
    libzip-dev \
    nano \
    unzip \
    vim \
    zip \
    zlib1g-dev

RUN docker-php-ext-install \
    pdo \
    pdo_mysql \
    soap \
    zip \
    && docker-php-ext-enable mongodb xdebug

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/ --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/  &&  \
    docker-php-ext-install gd

# Install latest node and npm
RUN apt-get update -yq \
    && curl -sL https://deb.nodesource.com/setup_12.x | bash \
    && apt-get install nodejs -yq

# Install composer
ENV COMPOSER_ALLOW_SUPERUSER=1
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    printf "\nPATH=\"~/.composer/vendor/bin:\$PATH\"\n" | tee -a ~/.bashrc

# Install cs-fixer
RUN curl -L https://cs.symfony.com/download/php-cs-fixer-v2.phar -o php-cs-fixer && \
    chmod a+x php-cs-fixer && \
    mv php-cs-fixer /usr/local/bin/php-cs-fixer

# Install deployer
RUN curl -LO https://deployer.org/deployer.phar && \
    mv deployer.phar /usr/local/bin/dep && \
    chmod +x /usr/local/bin/dep

RUN echo "echo; /usr/games/fortune | /usr/games/cowsay; echo" >> /root/.bashrc