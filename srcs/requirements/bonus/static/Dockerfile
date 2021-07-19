# get base image
FROM debian:buster

# set necessary env variables
ARG PORT_NUM_STATIC

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
    # to use envsubst
        gettext-base; \
    # delete apt-get caches
    rm -rf /var/lib/apt/lists;

# copy config template for Nginx Unit and css file for adminer
COPY ./conf/config.json.template /tmp/config.json.template
COPY ./tools/index.html /var/www/html/

# replace environment variables in template
RUN envsubst '$$PORT_NUM_STATIC' \
    < /tmp/config.json.template > /tmp/config.json; \
    rm /tmp/config.json.template;

# configure nginx Unit through REST API
RUN unitd \
    && curl \
    # send PUT request
        -X PUT \
    # passing data from JSON file
        -d @/tmp/config.json \
    # specify unix socket and url path
        --unix-socket /run/control.unit.sock http://localhost/config \
    # change permission and owner for html file
    && chmod -R 777 /var/www/html \
    && chown -R www-data:www-data /var/www/html

# expose port
EXPOSE ${PORT_NUM_STATIC}

# run unit in foregroud
ENTRYPOINT [ "unitd", "--no-daemon" ]
