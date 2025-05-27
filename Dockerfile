FROM php:8.2-fpm

#Install system dependecies
RUN apt-get update && apt-get install -y \
    libzip-dev unzip curl git libpng-dev libonig-dev libxml2-dev \
    && docker-php-ext-install zip pdo pdo_mysql mbstring bcmath

#Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

#set working derictory
WORKDIR /var/www

#copy project
COPY . .

#Install Laravel dependecies
RUN composer install --no-dev --optimize-autoloader

#Set permissions
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage

#Expose port
EXPOSE 8000

# Start Server
CMD php artisan serve --host=0.0.0.0 --port=8000