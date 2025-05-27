# Stable version
FROM debian:bullseye

RUN apt update -y && apt upgrade -y
RUN apt-get install -y nginx openssl

# Create SSL directory
RUN mkdir -p /etc/nginx/ssl

# Generate self-signed SSL certificate
RUN openssl req -x509 -nodes \
  -out /etc/nginx/ssl/inception.crt \
  -keyout /etc/nginx/ssl/inception.key \
  -subj "/C=FR/ST=IDF/L=Paris/O=42/OU=42/CN=saberton.42.fr/UID=saberton"

# Create nginx runtime directory
RUN mkdir -p /var/run/nginx

COPY conf/nginx.conf /etc/nginx/nginx.conf

# Set permissions for web directory
RUN chmod 755 /var/www/html
RUN chown -R www-data:www-data /var/www/html

CMD ["nginx", "-g", "daemon off;"]