FROM php:8.4-fpm

# Install system dependencies, PHP extensions, etc.
RUN apt-get update && apt-get install -y \
    git unzip zip curl libicu-dev libonig-dev libxml2-dev libzip-dev libpng-dev libpq-dev \
    && docker-php-ext-install pdo pdo_mysql zip intl opcache

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Copy your app files
WORKDIR /var/www/html
COPY composer.json composer.lock ./

# Install PHP dependencies
RUN composer install --no-dev --optimize-autoloader --no-scripts

# Copy the rest of your app
COPY . .

# (Optional) Run scripts if you want here, or run them later in container start
# RUN composer run-script post-install-cmd

CMD ["php-fpm"]
