#!/bin/bash

# Start temporary MariaDB instance to run setup commands
mysqld_safe --skip-grant-tables --skip-networking &

# Wait for MariaDB to start
while ! mysqladmin ping --silent; do
    sleep 1
done

# Secure installation and create database/users
mysql -uroot <<EOF
-- Set root password
UPDATE mysql.user SET Password=PASSWORD('$(cat ${MYSQL_ROOT_PASSWORD_FILE})') WHERE User='root';
DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
DELETE FROM mysql.user WHERE User='';
DELETE FROM mysql.db WHERE Db='test' OR Db='test_%';

-- Create database
CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

-- Create user
CREATE USER '${MYSQL_USER}'@'%' IDENTIFIED BY '$(cat ${MYSQL_PASSWORD_FILE})';
GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%';

-- Apply changes
FLUSH PRIVILEGES;
EOF

# Stop temporary instance
mysqladmin -uroot -p$(cat ${MYSQL_ROOT_PASSWORD_FILE}) shutdown

# Start normal MariaDB
exec mysqld_safe