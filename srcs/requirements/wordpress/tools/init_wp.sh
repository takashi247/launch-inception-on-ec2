#!/bin/bash

# install wp-cli
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar

chmod +x wp-cli.phar && \
mv wp-cli.phar /usr/local/bin/wp && \
cd wordpress/

wp core install \
    --url=localhost/wordpress \
    --title="My first blog" \
    --admin_user=wordpress \
    --admin_password=wordpress \
    --admin_email=wp@mail.com \
    --allow-root

wp user create \
    editor \
    editor@mail.com \
    --role=editor \
    --user_pass=editor \
    --allow-root
