#!/bin/bash
set -e

# small delay so mariadb container has time to start when using 'make up'
sleep 10

if [ -f /var/www/wordpress/wp-config.php ]; then
	echo "wordpress already installed"
else
	mkdir -p /var/www/wordpress
	cd /var/www/wordpress
	rm -rf ./*

# download wp-cli and make it available as `wp`
curl -s -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

wp core download --allow-root

mv /var/www/wordpress/wp-config-sample.php /var/www/wordpress/wp-config.php

wp config set --allow-root DB_NAME ${MYSQLDB}
wp config set --allow-root DB_USER ${MYSQLUSER}
wp config set --allow-root DB_PASSWORD ${MYSQLPASSWORD}
wp config set --allow-root DB_HOST "mariadb:3306"

wp core install --url="${W_DN}" --title="${W_TITLE}" \
--admin_user="${W_A_N}" --admin_password="${W_A_P}" \
--admin_email="${W_E_A}" --skip-email --allow-root

# optional additional user
if [ -n "${N_W_USER}" ] && [ -n "${N_W_EMAIL}" ]; then
	wp user create "${N_W_USER}" "${N_W_EMAIL}" --user_pass="${N_W_PASS}" --role="${N_W_ROLE}" --allow-root || true
fi

chown -R www-data:www-data /var/www/wordpress
fi

sed -i 's|^listen = /run/php/php8.2-fpm.sock|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf
# run the container command (php-fpm)
php-fpm8.2 -F -R