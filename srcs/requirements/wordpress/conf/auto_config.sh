#!/bin/bash
set -e

# Wait for DB service
sleep 10

WP_PATH="/var/www/wordpress"

if [ -f "$WP_PATH/wp-config.php" ]; then
    echo "✅ WordPress already installed"
else
    echo "⬇️ Installing WordPress..."

    mkdir -p "$WP_PATH"
    cd "$WP_PATH"

    # Install wp-cli if not available
    if ! command -v wp &>/dev/null; then
        curl -sO https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
        chmod +x wp-cli.phar
        mv wp-cli.phar /usr/local/bin/wp
    fi

    # Download WordPress
    wp core download --allow-root --path="$WP_PATH"

    # Generate wp-config.php
    wp config create \
        --allow-root \
        --dbname="${MYSQLDB}" \
        --dbuser="${MYSQLUSER}" \
        --dbpass="${MYSQLPASSWORD}" \
        --dbhost="mariadb:3306" \
        --path="$WP_PATH"

    # Install WordPress
    wp core install \
        --allow-root \
        --url="$W_DN" \
        --title="$W_TITLE" \
        --admin_user="$W_A_N" \
        --admin_password="$W_A_P" \
        --admin_email="$W_E_A" \
        --skip-email \
        --path="$WP_PATH"

    # Create extra user
    wp user create \
        "$N_W_USER" "$N_W_EMAIL" \
        --user_pass="$N_W_PASS" \
        --role="$N_W_ROLE" \
        --allow-root \
        --path="$WP_PATH"

    # Set permissions (safe)
    chown -R www-data:www-data "$WP_PATH"
    find "$WP_PATH" -type d -exec chmod 755 {} \;
    find "$WP_PATH" -type f -exec chmod 644 {} \;

    echo "✅ WordPress installation finished!"
fi

exec "$@"
