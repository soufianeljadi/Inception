# Use Debian Bookworm as base image
FROM debian:bookworm

# Install Nginx and OpenSSL
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y nginx openssl && \
    rm -rf /var/lib/apt/lists/*

# Create SSL directory and generate self-signed certificate
RUN mkdir -p /etc/nginx/ssl && \
    openssl req -x509 -nodes \
        -newkey rsa:2048 \
        -keyout /etc/nginx/ssl/inception.key \
        -out /etc/nginx/ssl/inception.crt \
        -subj "/C=MO/ST=KH/L=KH/O=1337/OU=1337/CN=sel-jadi.42.fr/UID=sel-jadi"

# Copy custom Nginx configuration
COPY conf/nginx.conf /etc/nginx/nginx.conf

# Expose HTTPS port
EXPOSE 443

# Run Nginx in foreground
CMD ["nginx", "-g", "daemon off;"]
