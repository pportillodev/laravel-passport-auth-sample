#!/bin/sh

echo "port:"
echo $PORT

php artisan optimize

sed -i "s,LISTEN_PORT,$PORT,g" /etc/nginx/nginx.conf
# CLOUD_SQL_CONNECTION_NAME=api-gateway-365814:us-central1:dev-db-01
# ./cloud_sql_proxy -instances=$CLOUD_SQL_CONNECTION_NAME=tcp:0.0.0.0:3306 \
#    -ip_address_types=PRIVATE 

php-fpm -D &&  nginx -g "daemon off;"

# while ! nc -w 1 -z 127.0.0.1 9000; do sleep 0.1; done;

# nginx