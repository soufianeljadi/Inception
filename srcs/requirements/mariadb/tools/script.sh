#!/bin/bash

service mariadb start

sleep 5

	mysqladmin -u root password "${MYSQLROOTPASSWORD}"
	mysql -e "CREATE DATABASE IF NOT EXISTS \`${MYSQLDB}\`;"
	mysql -e "CREATE USER IF NOT EXISTS \`${MSQLUSER}\`@'%' IDENTIFIED BY '${MYSQLPASSWORD}';"
	mysql -e "GRANT ALL PRIVILEGES ON ${MYSQLDB}.* TO \`${MSQLUSER}\`@'%' IDENTIFIED BY '${MYSQLPASSWORD}' ;"
	mysql -e "FLUSH PRIVILEGES;"
service mariadb stop


exec mysqld_safe 