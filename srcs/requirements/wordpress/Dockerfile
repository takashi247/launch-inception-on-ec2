# Get base image
FROM debian:bookworm-slim

# Set necessary env variables
ARG CONT_NAME_WORDPRESS
ARG PORT_NUM_WORDPRESS
ARG PORT_NUM_REDIS

# Get necessary applications
RUN set -ex; \
	apt-get update; \
	apt-get -y install \
	# to install wordpress and wordpress cli
		wget \
	# to install cgi interpreter for php
		php-cgi \
	# to install common utilities shared among all packaged PHP versions
		php-common \
	# to install fastCGI for php
		php-fpm \
	# to install PEAR (PHP Extension and Application Repository) based packages
		php-pear \
	# to handle multibyte encodings in PHP
		php-mbstring \
	# to install php zip module
		php-zip \
	# to enable socket communication
		php-net-socket \
	# to handle image processing
		php-gd \
	# a XML utility for php-pear
		php-xml-util \
	# to use gettext functions
		php-php-gettext \
	# to use MySQL module for php
		php-mysql \
	# to handle numbers
		php-bcmath \
	# use gosu for wordpress cli
		gosu \
	# to use envsubst
		gettext-base \
	# to use mysqladmin command in init_wp.sh
		mariadb-client; \
	# Remove apt-get caches
	rm -rf /var/lib/apt/lists;

# Copy php .conf file
COPY conf/www.conf.template /tmp

# Convert environment variables in template file
RUN envsubst '$$CONT_NAME_WORDPRESS$$PORT_NUM_WORDPRESS' \
	< /tmp/www.conf.template > /etc/php/8.2/fpm/pool.d/www.conf; \
	rm /tmp/www.conf.template;

# Copy wp-config file
COPY conf/wp-config.php /tmp/

# Copy shell script for wp-cli
COPY tools/init_wp.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/init_wp.sh

# expose port 9000 for wordpress and 6379 for redis in docker-network
EXPOSE ${PORT_NUM_WORDPRESS}
EXPOSE ${PORT_NUM_REDIS}

# make necessary directory for executing php-fpm8.2
RUN mkdir -p /run/php

# execute php-fpm in foreground
ENTRYPOINT ["php-fpm8.2", "-F"]
