#!/bin/bash
set -e

sleep 10

if [ -f /var/www/html/wp-config.php ]; then
	echo "wordpress already installed"
else
	cd /var/www/html
	rm -rf ./*

	curl -s -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
	chmod +x wp-cli.phar
	mv wp-cli.phar /usr/local/bin/wp

	wp core download --allow-root

	mv /var/www/html/wp-config-sample.php /var/www/html/wp-config.php
	wp config set --allow-root DB_NAME ${MYSQL_DATABASE}
	wp config set --allow-root DB_USER ${MYSQL_USER}
	wp config set --allow-root DB_PASSWORD ${MYSQL_PASSWORD}
	wp config set --allow-root DB_HOST ${MYSQL_HOSTNAME}

	wp core install --url="${WORDPRESS_DOMAIN_NAME}" --title="${WORDPRESS_TITLE}" \
	--admin_user="${WORDPRESS_ADMIN_NAME}" --admin_password="${WORDPRESS_ADMIN_PASSWORD}" \
	--admin_email="${WORDPRESS_ADMIN_EMAIL}" --skip-email --allow-root

	if [ -n "${WORDPRESS_USER_NAME}" ] && [ -n "${WORDPRESS_USER_EMAIL}" ]; then
		wp user create "${WORDPRESS_USER_NAME}" "${WORDPRESS_USER_EMAIL}" --user_pass="${WORDPRESS_USER_PASSWORD}" --role="${WORDPRESS_USER_ROLE}" --allow-root || true
	fi

	chown -R 755 /var/www/html
	sed -i 's|^listen = /run/php/php8.2-fpm.sock|listen = 9000|' /etc/php/8.2/fpm/pool.d/www.conf
fi
php-fpm8.2 -F -R