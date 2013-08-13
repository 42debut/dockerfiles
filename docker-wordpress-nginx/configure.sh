#!/bin/bash

# mysql has to be started this way as it doesn't work to call from /etc/init.d
/usr/bin/mysqld_safe &
sleep 10s

WWW_ROOT=/usr/share/nginx/www
WWW_USER=www-data

generate_password() {
  local length=$1
  pwgen -c -n -1 $length
}

# Here we generate random passwords
# The first two are for mysql users, the last batch for random keys in wp-config.php
WORDPRESS_DB="wordpress"
MYSQL_PASSWORD=`generate_password 12`
WORDPRESS_PASSWORD=`generate_password 12`

# This is so the passwords show up in logs.
echo mysql root password: $MYSQL_PASSWORD
echo wordpress password: $WORDPRESS_PASSWORD

echo $MYSQL_PASSWORD > /mysql-root-pw.txt
echo $WORDPRESS_PASSWORD > /wordpress-db-pw.txt

sed -e "s/database_name_here/$WORDPRESS_DB/
s/username_here/$WORDPRESS_DB/
s/password_here/$WORDPRESS_PASSWORD/
/'AUTH_KEY'/s/put your unique phrase here/`generate_password 65`/
/'SECURE_AUTH_KEY'/s/put your unique phrase here/`generate_password 65`/
/'LOGGED_IN_KEY'/s/put your unique phrase here/`generate_password 65`/
/'NONCE_KEY'/s/put your unique phrase here/`generate_password 65`/
/'AUTH_SALT'/s/put your unique phrase here/`generate_password 65`/
/'SECURE_AUTH_SALT'/s/put your unique phrase here/`generate_password 65`/
/'LOGGED_IN_SALT'/s/put your unique phrase here/`generate_password 65`/
/'NONCE_SALT'/s/put your unique phrase here/`generate_password 65`/" $WWW_ROOT/wp-config-sample.php > $WWW_ROOT/wp-config.php

# Download nginx helper plugin
curl -O `curl -i -s http://wordpress.org/plugins/nginx-helper/ | egrep -o "http://downloads.wordpress.org/plugin/[^']+"`
unzip nginx-helper.*.zip -d $WWW_ROOT/wp-content/plugins
chown -R $WWW_USER:$WWW_USER $WWW_ROOT/wp-content/plugins/nginx-helper

# Activate nginx plugin and set up pretty permalink structure once logged in
cat << ENDL >> $WWW_ROOT/wp-config.php
\$plugins = get_option( 'active_plugins' );
if ( count( \$plugins ) === 0 ) {
  require_once( ABSPATH . '/wp-admin/includes/plugin.php' );
  \$wp_rewrite->set_permalink_structure( '/%postname%/' );
  \$pluginsToActivate = array( 'nginx-helper/nginx-helper.php' );
  foreach ( \$pluginsToActivate as \$plugin ) {
    if ( !in_array( \$plugin, \$plugins ) ) {
      activate_plugin( ABSPATH . '/wp-content/plugins/' . \$plugin );
    }
  }
}
ENDL

chown $WWW_USER:$WWW_USER $WWW_ROOT/wp-config.php

mysqladmin -u root password $MYSQL_PASSWORD
mysql -uroot -p$MYSQL_PASSWORD -e "CREATE DATABASE wordpress; GRANT ALL PRIVILEGES ON wordpress.* TO 'wordpress'@'localhost' IDENTIFIED BY '$WORDPRESS_PASSWORD'; FLUSH PRIVILEGES;"
killall mysqld
