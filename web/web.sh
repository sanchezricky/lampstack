#!/usr/bin/env bash

set -euo pipefail

# Update APT
apt-get update -y

# Install Apache2
apt-get install apache2 -y

# Install PHP and the dependencies
apt-get install php7.0 libapache2-mod-php7.0 php7.0-mcrypt php7.0-mysql php7.0-gd php-ssh2 -y

# MySQL install
apt-get install mysql-client -y

# Adding ServerName and IP
echo "ServerName 192.168.56.10" >> /etc/apache2/apache2.conf

# Edit the dir.conf and prioritize index.php
echo "
<IfModule mod_dir.c>
     DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>" > /etc/apache2/mods-enabled/dir.conf

# Download Wordpress into /tmp directory
wget http://wordpress.org/latest.tar.gz -O /tmp/latest.tar.gz

# Unzip the WordPress
tar xzvf /tmp/latest.tar.gz -C /

# Copy the wp-config-sample.php to wp-config-php
cp /wordpress/wp-config-sample.php /wordpress/wp-config.php

# Edit the wp-config file to include databse, user, password, and data IP
sed -i "/DB_NAME/c\define('DB_NAME', 'wordpress');" /wordpress/wp-config.php

sed -i "/DB_USER/c\define('DB_USER', 'wordpressuser');" /wordpress/wp-config.php

sed -i "/DB_PASSWORD/c\define('DB_PASSWORD', 'password');" /wordpress/wp-config.php

sed -i "/DB_HOST/c\define('DB_HOST', '192.168.56.20');" /wordpress/wp-config.php

# Copy WordPress folder into document root
rsync -avP /wordpress/ /var/www/html/

# Creating uploads folder
mkdir /var/www/html/wp-content/uploads

# Granting permissions to Apache 
chown -R ubuntu:www-data /var/www/html

# Restarting Apache2
systemctl restart apache2
