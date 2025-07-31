# Use Debian stable as base image
FROM debian:bullseye

# Install dependencies
RUN apt-get update && apt-get install -y \
    nginx \
    openssl \
    && rm -rf /var/lib/apt/lists/*

# Remove default configuration
RUN rm -rf /etc/nginx/sites-enabled/default

# Copy custom configuration
COPY conf/nginx.conf /etc/nginx/conf.d/yourlogin.42.fr.conf
COPY conf/certs/nginx.crt /etc/ssl/certs/nginx.crt
COPY conf/certs/nginx.key /etc/ssl/certs/nginx.key

# Configure nginx
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

# Expose HTTPS port
EXPOSE 443

# Start nginx in foreground
CMD ["nginx", "-g", "daemon off;"]