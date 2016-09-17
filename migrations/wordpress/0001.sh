#!/bin/bash

# Set up MySQL
ln -sf /etc/mysql-initscripts/mysql-5.6 /etc/init.d/mysql1-0
ln -sf /usr/local/mysql-latest /usr/local/mysql
PATH=$PATH:/usr/local/mysql/bin/

mkdir -p /var/log/mysql1-0
chown mysql.mysql /var/log/mysql1-0
cd /usr/local/mysql5.6/
./scripts/mysql_install_db --defaults-file=/etc/mysql/mysql1-0.cnf --user=mysql --datadir=/var/lib/mysql1-0 --force  --skip-name-resolve
chown -R mysql.mysql /var/lib/mysql1-0

# Start MySQL & add database
/etc/init.d/mysql1-0 start
/usr/local/mysql/bin/mysqladmin --defaults-file=/etc/mysql/mysql1-0.cnf -u root password 'god'
mysql --defaults-file=/etc/mysql/mysql1-0.cnf -u root -sN  -pgod -e "CREATE DATABASE wp;"
mysql --defaults-file=/etc/mysql/mysql1-0.cnf -u root -sN  -pgod -e "CREATE USER 'wp'@'localhost' IDENTIFIED BY 'drupal';"
mysql --defaults-file=/etc/mysql/mysql1-0.cnf -u root -sN  -pgod -e "GRANT ALL ON wp.* TO 'wp'@'localhost';"

# Install WordPress
curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
chmod +x wp-cli.phar
mv wp-cli.phar /usr/local/bin/wp

mkdir /var/www
cd /var/www
wp core download --allow-root

# Restart nginx
service nginx restart
