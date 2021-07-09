# Get base image
FROM debian:buster

# Set necessary env variables
ARG CONT_NAME_WORDPRESS
ARG PORT_NUM_WORDPRESS

# Get necessary applications
RUN set -ex; \
	apt-get update; \
	apt-get -y install wget curl vim \
		php-cgi php-common php-fpm php-pear php-mbstring php-zip \
		php-net-socket php-gd php-xml-util php-gettext php-mysql \
		php-bcmath \
	# use gosu for wordpress cli
		gosu \
	# to use envsubst
		gettext-base \
	# to use mysqladmin command in init_wp.sh
		mariadb-client; \
	# Remove apt-get caches
	rm -rf /var/lib/apt/lists;

# Set working directory
WORKDIR /var/www/html

# Modify config file for phpMyadmin
# COPY conf/config.inc.php phpmyadmin/

# Copy php .conf file
COPY conf/www.conf.template /tmp

# Convert environment variables in template file
RUN envsubst '$$CONT_NAME_WORDPRESS$$PORT_NUM_WORDPRESS' \
	< /tmp/www.conf.template > /etc/php/7.3/fpm/pool.d/www.conf

# Copy wp-config file
COPY conf/wp-config.php /tmp/

# Copy shell script for wp-cli
COPY tools/init_wp.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/init_wp.sh

# Change owner of all files in the html directory
RUN chown -R www-data:www-data .

# expose port 9000 in docker-network
EXPOSE ${PORT_NUM_WORDPRESS}

# make necessary directory for executing php-fpm7.3
RUN mkdir -p /run/php

# execute php-fpm in foreground
CMD ["php-fpm7.3", "-F"]
