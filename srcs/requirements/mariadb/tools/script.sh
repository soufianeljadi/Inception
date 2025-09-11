#!/bin/bash
set -e

# Start MariaDB in the background
service mariadb start
sleep 5

# Secure root password
mysqladmin -u root password "${MYSQLROOTPASSWORD}" || true

# Create DB, user, and grant privileges
mysql -uroot -p"${MYSQLROOTPASSWORD}" <<-EOSQL
    CREATE DATABASE IF NOT EXISTS \`${MYSQLDB}\`;
    CREATE USER IF NOT EXISTS \`${MYSQLUSER}\`@'%' IDENTIFIED BY '${MYSQLPASSWORD}';
    GRANT ALL PRIVILEGES ON \`${MYSQLDB}\`.* TO \`${MYSQLUSER}\`@'%';
    FLUSH PRIVILEGES;
EOSQL

# Stop temp service and run MariaDB safely
service mariadb stop
exec mysqld_safe
