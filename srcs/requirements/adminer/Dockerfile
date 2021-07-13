# get base image
FROM debian:buster

# set necessary env variables
ARG PORT_NUM_ADMINER

# get curl to download adminer and congiture Nginx Unit
RUN set -ex; \
    apt-get update; \
    apt-get -y install \
    curl \
    gnupg;

# download Nginx's signing key and add it to apt's keyring to eliminate warnings during Unit installation
RUN curl -sL https://nginx.org/keys/nginx_signing.key | apt-key add -

# configure Unit's repository
COPY ./conf/unit.list /etc/apt/sources.list.d/

# get necessary applications
RUN set -ex; \
    apt-get update; \
    apt-get -y install \
    # install unit and related packages
        unit \
        unit-php \
        php \
        php-mysql \
    # to use envsubst
        gettext-base; \
    # delete apt-get caches
    rm -rf /var/lib/apt/lists;

# download adminer
RUN mkdir -p /var/www/html \
    && curl -L https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php \
    > /var/www/html/adminer.php

# copy config template for Nginx Unit and css file for adminer
COPY ./conf/config.json.template /tmp/config.json.template
COPY ./conf/adminer.css /var/www/html/adminer.css

# replace environment variables in template
RUN envsubst '$$PORT_NUM_ADMINER' \
    < /tmp/config.json.template > /tmp/config.json

# configure nginx Unit through REST API
RUN unitd \
    && curl \
    # send PUT request
        -X PUT \
    # passing data from JSON file
        -d @/tmp/config.json \
    # specify unix socket and url path
        --unix-socket /run/control.unit.sock http://localhost/config \
    # change permission for css file
    && chmod +r /var/www/html/adminer.css

# expose port
EXPOSE ${PORT_NUM_ADMINER}

# run unit in foregroud
CMD [ "unitd", "--no-daemon" ]
