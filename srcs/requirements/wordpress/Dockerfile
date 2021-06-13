# Get base image
FROM debian:buster

# Get necessary applications
RUN set -ex; \
	apt-get update; \
	apt-get -y install wget curl vim \
		php-cgi php-common php-fpm php-pear php-mbstring php-zip \
		php-net-socket php-gd php-xml-util php-gettext php-mysql \
		php-bcmath; \
	# Remove apt-get caches
	rm -rf /var/lib/apt/lists;

# Set working directory
WORKDIR /var/www/html

# Install wordpress
RUN set -ex; \
	wget https://wordpress.org/latest.tar.gz; \
	tar -xvzf latest.tar.gz; \
	rm latest.tar.gz;

# Install phpmyadmin
RUN	wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz; \
	tar -xvzf phpMyAdmin-5.0.2-all-languages.tar.gz; \
	rm phpMyAdmin-5.0.2-all-languages.tar.gz; \
	mv phpMyAdmin-5.0.2-all-languages phpmyadmin; \
	rm phpmyadmin/config.sample.inc.php;

# Modify config file for phpMyadmin
COPY conf/config.inc.php phpmyadmin/

# Copy php conf. file
COPY conf/www.conf /etc/php/7.3/fpm/pool.d/

# Copy wp-config file
COPY conf/wp-config.php wordpress/

# Change owner of all files in the html directory
RUN chown -R www-data:www-data .

# expose port 9000 in docker-network
EXPOSE 9000

# make necessary directory for executing php-fpm7.3
RUN mkdir -p /run/php

# execute php-fpm in foreground
CMD ["php-fpm7.3", "-F"]
