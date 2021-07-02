#!/bin/bash

# run codes below if wordpress directory is empty
if [ ! "$(ls -A /var/www/tnishina.42.fr/wordpress)" ]; then
    # move config file from tmp directory
    mv /tmp/wp-config.php /var/www/tnishina.42.fr/wordpress/
    # install wordpress
    cd /tmp
	wget https://wordpress.org/latest.tar.gz
	tar -xvzf latest.tar.gz
	rm latest.tar.gz
    mv wordpress/* /var/www/tnishina.42.fr/wordpress
    chown -R www-data:www-data /var/www/tnishina.42.fr/wordpress/
    # install wp-cli
    cd /var/www/tnishina.42.fr
    wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
    chmod +x wp-cli.phar
    mv wp-cli.phar /usr/local/bin/wp
    cd wordpress/
    # wait until mariadb is up and running
    while ! mysqladmin ping -h mariadb --silent; do
        sleep 1
    done
    # install wordpress
    wp core install \
        --url=localhost/wordpress \
        --title="My first blog" \
        --admin_user=wordpress \
        --admin_password=wordpress \
        --admin_email=wp@mail.com \
        --allow-root
    # create users
    wp user create \
        editor \
        editor@mail.com \
        --role=editor \
        --user_pass=editor \
        --allow-root
fi
