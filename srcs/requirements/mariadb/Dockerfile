# Get base image
FROM debian:buster

# Set Entrykit version
ENV ENTRYKIT_VERSION 0.4.0

# Get necessary applications
RUN set -ex; \
	apt-get update; \
	apt-get -y install wget curl vim \
		mariadb-server mariadb-client; \
	# Remove apt-get caches
	rm -rf /var/lib/apt/lists;

# Copy shell script
COPY sh_scripts/init_mariadb.sh /tmp/share/

# Change owner of all files in the html directory
# RUN chown -R www-data:www-data .

# Keep running the container
ENTRYPOINT [ "render", "/etc/nginx/sites-available/default", "--", "bash", "/tmp/share/init_mariadb.sh"]
