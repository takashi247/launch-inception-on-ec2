#!/bin/bash

# run codes below if wordpress directory is empty
if [ ! "$(ls -A /var/www/${DOMAIN_NAME})" ]; then
    # move config file from tmp directory
    mv /tmp/wp-config.php /var/www/${DOMAIN_NAME}/
    # install wordpress
    cd /tmp
	wget https://wordpress.org/latest.tar.gz
	tar -xvzf latest.tar.gz
	rm latest.tar.gz
    mv wordpress/* /var/www/${DOMAIN_NAME}
    rmdir wordpress
    chown -R www-data:www-data /var/www/${DOMAIN_NAME}/
    # install wp-cli
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
    cd /var/www/${DOMAIN_NAME}/
    # wait until mariadb is up and running
    while ! mysqladmin ping -h mariadb --silent; do
        sleep 1
    done
    # install wordpress as www-data using gosu
    gosu www-data \
        /usr/local/bin/wp core install \
        --url=${DOMAIN_NAME} \
        --title="${TITLE}" \
        --admin_user=${ADMIN_USER} \
        --admin_password=${ADMIN_PASSWORD} \
        --admin_email=${ADMIN_EMAIL}

    # create users as www-data using gosu
    gosu www-data \
        /usr/local/bin/wp user create \
        ${USER_LOGIN} \
        ${USER_EMAIL} \
        --role=${ROLE} \
        --user_pass=${USER_PASSWORD}

    # install redis cache plugin
    gosu www-data \
        /usr/local/bin/wp plugin install redis-cache --activate

    # enable redis cache
    gosu www-data /usr/local/bin/wp redis enable

fi
