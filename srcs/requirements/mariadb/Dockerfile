# Use Debian Bookworm as base image
FROM debian:bookworm

# Install MariaDB server
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y mariadb-server && \
    rm -rf /var/lib/apt/lists/*

# Copy custom MariaDB configuration
COPY conf/50-server.cnf /etc/mysql/mariadb.conf.d/50-server.cnf

# Copy initialization script
COPY tools/script.sh /script.sh
RUN chmod +x /script.sh

# Expose default MariaDB port
EXPOSE 3306

# Run custom entrypoint script
ENTRYPOINT ["/script.sh"]
