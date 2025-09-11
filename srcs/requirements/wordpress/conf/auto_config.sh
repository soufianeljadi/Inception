#!/bin/bash

sleep 10
if [ -f /var/www/wordpress/wp-config.php ]; then
    echo "wordpress already installed"
else
	mkdir -p /var/www/wordpress

	cd /var/www/wordpress

	rm -rf *

	curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar  

	chmod +x wp-cli.phar

	mv wp-cli.phar /usr/local/bin/wp

	chmod -R 777 /var/www/wordpress/

	wp core download --allow-root

	mv /var/www/wordpress/wp-config-sample.php  /var/www/wordpress/wp-config.php

	wp config set --allow-root DB_NAME ${MYSQLDB} 
	wp config set --allow-root DB_USER ${MSQLUSER}
	wp config set --allow-root DB_PASSWORD ${MYSQLPASSWORD}
	wp config set --allow-root DB_HOST "mariadb:3306"

	wp core install --url=$W_DN --title=$W_TITLE --admin_user=$W_A_N --admin_password=$W_A_P --admin_email=$W_E_A --skip-email --allow-root 

	wp user create ${N_W_USER} ${N_W_EMAIL} --user_pass=$N_W_PASS --role=$N_W_ROLE --allow-root

fi
exec "$@"