# Get base image
FROM debian:buster

# Set Entrykit version
ENV ENTRYKIT_VERSION 0.4.0

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

# Install wordpress and phpmyadmin
RUN set -ex; \
	wget https://wordpress.org/latest.tar.gz; \
	tar -xvzf latest.tar.gz; \
	rm latest.tar.gz; \
# Install phpmyadmin
	wget https://files.phpmyadmin.net/phpMyAdmin/5.0.2/phpMyAdmin-5.0.2-all-languages.tar.gz; \
	tar -xvzf phpMyAdmin-5.0.2-all-languages.tar.gz; \
	rm phpMyAdmin-5.0.2-all-languages.tar.gz; \
	mv phpMyAdmin-5.0.2-all-languages phpmyadmin; \
	rm phpmyadmin/config.sample.inc.php; \
# Install Entrykit
	wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz; \
	tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz; \
	rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz; \
	mv entrykit /bin/entrykit; \
	chmod +x /bin/entrykit; \
	entrykit --symlink;

# Modify wp-config file
COPY config/wp-config.php wordpress/

# Modify config file for phpMyadmin
COPY config/config.inc.php phpmyadmin/

# Copy shell script
COPY sh_scripts/init_wordpress.sh /tmp/share/

# Change owner of all files in the html directory
RUN chown -R www-data:www-data .

# Keep running the container
ENTRYPOINT [ "render", "/etc/nginx/sites-available/default", "--", "bash", "/tmp/share/init_wordpress.sh"]
