#!/bin/bash

service mariadb start

until mysqladmin ping -h "localhost" --silent; do
  sleep 1
done

	mysqladmin -u root password "${MYSQLROOTPASSWORD}"
	mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQLDB}\`;"
	mysql -e "CREATE USER IF NOT EXISTS \`${MYSQLUSER}\`@'%' IDENTIFIED BY '${MYSQLPASSWORD}';"
	mysql -e "GRANT ALL PRIVILEGES ON ${MYSQLDB}.* TO \`${MYSQLUSER}\`@'%' IDENTIFIED BY '${MYSQLPASSWORD}' ;"
	mysql -e "FLUSH PRIVILEGES;"
service mariadb stop


exec mysqld_safe --bind-address=0.0.0.0