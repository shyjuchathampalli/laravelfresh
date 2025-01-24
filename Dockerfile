# Use an official PHP runtime as a parent image
FROM php:8.2-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    curl \
    zip \
    unzip \
    git \
    libmcrypt-dev \
    libjpeg-dev \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    && docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd

# Set working directory
WORKDIR /var/www

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy application files
COPY . .

# Set permissions
RUN chown -R www-data:www-data /var/www \
    && chmod -R 755 /var/www/storage

# Expose port 8080 and start PHP-FPM server
EXPOSE 8080
#RUN sed -i 's/listen = 9000/listen = 8080/' /usr/local/etc/php-fpm.d/www.conf
RUN sed -i 's/listen = 9000/listen = 0.0.0.0:8080/' /usr/local/etc/php-fpm.d/www.conf
CMD ["php-fpm"]
