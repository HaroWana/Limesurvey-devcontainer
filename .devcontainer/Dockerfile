FROM php:8.1-fpm

RUN apt-get update && apt-get install -y \
    nginx \
    git \
    unzip \
    curl \
    wget \
    libpq-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libicu-dev \
    libldap2-dev \
    libxml2-dev \
    libssl-dev \
    libonig-dev \
    libkrb5-dev \
    libc-client-dev \
    zip \
    postgresql-client \
    procps \
    supervisor \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install gd intl ldap imap pdo pdo_pgsql zip \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy config files
COPY php/php.ini /usr/local/etc/php/php.ini
COPY php/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
COPY nginx/default.conf /etc/nginx/sites-available/default
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

WORKDIR /workspace

CMD ["/usr/bin/supervisord"]
