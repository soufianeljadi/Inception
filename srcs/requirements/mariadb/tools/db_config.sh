#!/bin/bash

service mariadb start

sleep 5

	mysqladmin -u root password "${MYSQL_ROOT_PASSWORD}"
	mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
	mysql -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
	mysql -e "GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' ;"
	mysql -e "FLUSH PRIVILEGES;"
service mariadb stop


exec mysqld_safe