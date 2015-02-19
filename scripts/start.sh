#!/bin/bash
if [ ! -f /var/www/wp-config.php ]; then
/usr/bin/mysqld_safe &
sleep 10s
# Generering av password
WORDPRESS_DB="wordpress"
MYSQL_PASSWORD=`pwgen -c -n -1 12`
WORDPRESS_PASSWORD=`pwgen -c -n -1 12`
# Visa i logg
echo mysql root password: $MYSQL_PASSWORD
echo wordpress password: $WORDPRESS_PASSWORD
echo $MYSQL_PASSWORD > /mysql-root-pw.txt
echo $WORDPRESS_PASSWORD > /wordpress-db-pw.txt
sed -e "s/database_name_here/$WORDPRESS_DB/
s/username_here/$WORDPRESS_DB/
s/password_here/$WORDPRESS_PASSWORD/
/'AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'SECURE_AUTH_KEY'/s/put your unique phrase here/`pwgen -c -n 65`/
/'NONCE_KEY'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'SECURE_AUTH_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'LOGGED_IN_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/
/'NONCE_SALT'/s/put your unique phrase here/`pwgen -c -n -1 65`/" /var/www/wp-config-sample.php > /var/www/wp-config.php

mv /etc/php5/apache2/php.ini /etc/php5/apache2/php.ini.orig
sed "s/upload_max_filesize = 2M/upload_max_filesize = 20M/" /etc/php5/apache2/php.ini.orig > /etc/php5/apache2/php.ini

chown www-data:www-data /var/www/wp-config.php
mysqladmin -u root password $MYSQL_PASSWORD
mysql -uroot -p$MYSQL_PASSWORD -e "CREATE DATABASE wordpress; GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY '$WORDPRESS_PASSWORD'; FLUS$
killall mysqld

sleep 10s
fi
supervisord -n
