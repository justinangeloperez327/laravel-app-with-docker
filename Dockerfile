# Use PHP 8.4 official image
FROM php:8.4-fpm

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libonig-dev libxml2-dev \
    libzip-dev libcurl4-openssl-dev libssl-dev \
    npm nodejs

# Clean up cache
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install pdo pdo_mysql mbstring exif pcntl bcmath gd zip

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer

# Set working directory
WORKDIR /var/www

# Copy app files into the container
COPY . /var/www

# Optional: Install Node.js 24 manually (or remove if already included)
RUN curl -fsSL https://deb.nodesource.com/setup_24.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest

# Permissions (optional)
RUN chown -R www-data:www-data /var/www && chmod -R 755 /var/www

# Expose port for Laravel dev server
EXPOSE 8000

# Default command (overridden in docker-compose)
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
