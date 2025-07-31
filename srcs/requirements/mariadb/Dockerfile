# Use Debian stable as base image
FROM debian:bullseye

# Install MariaDB
RUN apt-get update && apt-get install -y \
    mariadb-server \
    && rm -rf /var/lib/apt/lists/*

# Copy setup script
COPY tools/setup.sh /tmp/setup.sh

# Configure MariaDB
RUN mkdir -p /var/run/mysqld \
    && chown -R mysql:mysql /var/run/mysqld \
    && chmod 777 /var/run/mysqld

# Expose MySQL port
EXPOSE 3306

# Start MariaDB
CMD ["sh", "-c", "exec mysqld_safe --init-file=/tmp/setup.sh"]