#!/usr/bin/env bash

set -euo pipefail

# Update APT
apt-get update -y

# Silent install for MySQL
debconf-set-selections <<< 'mysql-server mysql-server/root_password password password'
debconf-set-selections <<< 'mysql-server mysql-server/root_password_again password password'

# MySQL install
apt-get install mysql-server -y

# Change bind address to server ip
sed -i "/bind-address/c\bind-address = 192.168.56.20" /etc/mysql/mysql.conf.d/mysqld.cnf

# Create Database, User, Password, and grant privileges for MySQL
mysql -uroot -ppassword -e "CREATE DATABASE wordpress;"
mysql -uroot -ppassword -e "CREATE USER 'wordpressuser'@'192.168.56.10' IDENTIFIED BY 'password';"
mysql -uroot -ppassword -e "GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpressuser'@'192.168.56.10';"
mysql -uroot -ppassword -e "FLUSH PRIVILEGES;"

# Restart MySQL
systemctl restart mysql.service

echo "Database installed!"
