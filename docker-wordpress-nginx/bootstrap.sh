#!/bin/sh

if [ ! -f /usr/share/nginx/www/wp-config.php ]; then
    ./configure.sh
fi

./start.sh