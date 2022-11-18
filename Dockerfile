FROM php:8.1-fpm

# RUN apk add --no-cache nginx wget php7.4-gmp
RUN apt-get update && apt-get install -y \
    git \
    curl \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libcurl4-openssl-dev \
    libgmp-dev \
    zip \
    unzip \
    wget \
    nginx

# Clear cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo_mysql curl gmp dom

# RUN mkdir -p /run/nginx

COPY docker/nginx.conf /etc/nginx/nginx.conf

RUN mkdir -p /app
COPY docker/startup.sh /app
#COPY . /app
COPY ./src /var/www

RUN chmod +rwx /var/www

RUN chmod -R 777 /var/www

RUN sh -c "wget http://getcomposer.org/composer.phar && chmod a+x composer.phar && mv composer.phar /usr/local/bin/composer"

RUN cd /var/www && \
    /usr/local/bin/composer update

RUN cd /var/www && \
    /usr/local/bin/composer install --no-dev


RUN mkdir  -p /var/www/storage/framework/sessions
RUN mkdir  -p /var/www/storage/framework/views
RUN mkdir  -p /var/www/storage/framework/cache

RUN ls -la /var/www/storage/framework/

RUN cd /var/www/ && php artisan --version

RUN cd /var/www/ && php artisan config:cache

RUN cd /var/www/ && php artisan cache:clear
RUN cd /var/www/ && php artisan config:clear
RUN cd /var/www/ && php artisan view:clear

RUN chown -R www-data: /var/www/

EXPOSE 80

RUN ["chmod", "+x", "/app/startup.sh"]
CMD sh /app/startup.sh
