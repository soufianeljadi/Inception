# Use Debian Bookworm as base image
FROM debian:bookworm

# Install PHP, FPM, and required extensions
RUN apt-get update && \
    apt-get install -y curl git wget php php-fpm php-mysql && \
    rm -rf /var/lib/apt/lists/*

# Copy custom PHP-FPM pool configuration
COPY conf/www.conf /etc/php/8.2/fpm/pool.d/www.conf

# Copy WordPress auto-configuration script
COPY conf/auto_config.sh /auto_config.sh
RUN chmod +x /auto_config.sh

# Set working directory for WordPress
WORKDIR /var/www/wordpress

# Ensure PHP runtime directory exists
RUN mkdir -p /run/php

# Expose PHP-FPM port
EXPOSE 9000

# Run auto-configuration script first
ENTRYPOINT ["bash", "/auto_config.sh"]

# Start PHP-FPM in foreground
CMD ["php-fpm8.2", "-F"]
