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
        php-mysql; \
    # delete apt-get caches
    rm -rf /var/lib/apt/lists;

# download adminer
RUN mkdir -p /var/www/html \
    && curl -L https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php \
    > /var/www/html/adminer.php

# copy config file for Nginx Unit and css file for adminer
COPY ./conf/config.json /tmp/config.json
COPY ./conf/adminer.css /var/www/html/adminer.css

# configure nginx Unit through REST API
RUN unitd \
    && curl -X PUT -d @/tmp/config.json --unix-socket /run/control.unit.sock http://localhost/config \
    && chmod +r /var/www/html/adminer.css

# expose port
EXPOSE ${PORT_NUM_ADMINER}

# run unit in foregroud
CMD [ "unitd", "--no-daemon" ]
