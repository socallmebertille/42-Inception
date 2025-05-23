#!/bin/sh
set -e

WP_PATH="/var/www/html"

# Créer le répertoire pour PHP-FPM si il n'existe pas
mkdir -p /run/php

# Vérifier si WordPress est déjà téléchargé
if [ ! -f "$WP_PATH/wp-load.php" ]; then
  echo "Téléchargement de WordPress..."
  wp core download --path="$WP_PATH" --allow-root
fi

# Créer le fichier wp-config.php
cat <<EOF > "$WP_PATH/wp-config.php"
<?php
define('DB_NAME', '${MYSQL_DATABASE}');
define('DB_USER', '${MYSQL_USER}');
define('DB_PASSWORD', '${MYSQL_PASSWORD}');
define('DB_HOST', '${WP_DB_HOST}');
define('DB_CHARSET', 'utf8');
define('DB_COLLATE', '');
\$table_prefix = 'wp_';
define('WP_DEBUG', false);
if ( !defined('ABSPATH') ) define('ABSPATH', __DIR__ . '/');
require_once ABSPATH . 'wp-settings.php';
EOF

# Attendre que MariaDB soit prêt
echo "Attente de MariaDB..."
until mysql -h "${WP_DB_HOST}" -u "${MYSQL_USER}" -p"${MYSQL_PASSWORD}" -e "SELECT 1" > /dev/null 2>&1; do
  echo "Attente de MariaDB... ($(date))"
  sleep 5
done

echo "MariaDB est prêt!"

# Assurer les bonnes permissions
chown -R www-data:www-data "$WP_PATH"
chmod -R 755 "$WP_PATH"

# Installer WordPress si ce n'est pas déjà fait
if ! wp core is-installed --path="$WP_PATH" --allow-root; then
  echo "Installation de WordPress..."
  wp core install \
    --path="$WP_PATH" \
    --url="https://${DOMAIN_NAME}" \
    --title="${WP_TITLE}" \
    --admin_user="${WP_ADMIN}" \
    --admin_password="${WP_ADMIN_PASSWORD}" \
    --admin_email="${WP_ADMIN_EMAIL}" \
    --allow-root
  
  echo "Création de l'utilisateur..."
  wp user create "${WP_USER}" "${WP_USER_EMAIL}" \
    --user_pass="${WP_USER_PASSWORD}" \
    --role=editor \
    --path="$WP_PATH" \
    --allow-root
fi

echo "Démarrage de PHP-FPM..."
exec /usr/sbin/php-fpm7.4 -F