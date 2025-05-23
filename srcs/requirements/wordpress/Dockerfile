FROM debian:bullseye

RUN apt update -y && apt upgrade -y
RUN apt-get install -y php7.4 php7.4-fpm php7.4-mysql wget curl unzip mariadb-client sed

# Créer les répertoires nécessaires pour PHP-FPM
RUN mkdir -p /run/php
RUN mkdir -p /var/www/html
RUN chown -R www-data:www-data /var/www/html
RUN chmod -R 755 /var/www/html

# Télécharger et installer WordPress
RUN wget https://wordpress.org/latest.tar.gz && tar -xzf latest.tar.gz && \
    mv wordpress/* /var/www/html && rm -rf wordpress latest.tar.gz

# Configuration PHP-FPM
RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/7.4/fpm/pool.d/www.conf
RUN sed -i 's|^;listen.owner = .*|listen.owner = www-data|' /etc/php/7.4/fpm/pool.d/www.conf
RUN sed -i 's|^;listen.group = .*|listen.group = www-data|' /etc/php/7.4/fpm/pool.d/www.conf
RUN sed -i 's|^;listen.mode = .*|listen.mode = 0660|' /etc/php/7.4/fpm/pool.d/www.conf

# Configurer le fichier PID pour PHP-FPM
RUN sed -i 's|^;pid = .*|pid = /run/php/php7.4-fpm.pid|' /etc/php/7.4/fpm/php-fpm.conf

COPY tools/setup.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/setup.sh

# Installer WP-CLI
RUN wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar
RUN mv wp-cli.phar /usr/local/bin/wp

EXPOSE 9000

ENTRYPOINT ["/usr/local/bin/setup.sh"]
CMD ["/usr/sbin/php-fpm7.4", "-F"]