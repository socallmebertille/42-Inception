#!/bin/bash

export DEBIAN_FRONTEND=noninteractive

# Démarrer MariaDB
service mariadb start
sleep 10

# Vérifier si la base de données existe déjà
DB_EXISTS=$(mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "SHOW DATABASES LIKE '${MYSQL_DATABASE}'" 2>/dev/null | wc -l)

if [ "$DB_EXISTS" -eq 0 ]; then
    echo "Création de la base de données et des utilisateurs..."
    
    # Créer la base de données
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
    
    # Créer l'utilisateur
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "CREATE USER IF NOT EXISTS \`${MYSQL_USER}\`@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
    
    # Donner les privilèges
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO \`${MYSQL_USER}\`@'%';"
    
    # Modifier le mot de passe root
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
    
    # Actualiser les privilèges
    mysql -u root -p"${MYSQL_ROOT_PASSWORD}" -e "FLUSH PRIVILEGES;"
    
    echo "Configuration terminée."
else
    echo "Base de données déjà configurée."
fi

# Arrêter MariaDB proprement et redémarrer avec mysqld_safe
mysqladmin -u root -p"${MYSQL_ROOT_PASSWORD}" shutdown
exec mysqld_safe