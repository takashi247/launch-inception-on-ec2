# Get base image
FROM debian:buster

# Get necessary applications
RUN set -ex; \
	apt-get update; \
	apt-get -y install wget curl vim \
		mariadb-server mariadb-client; \
	# Remove apt-get caches
	rm -rf /var/lib/apt/lists;

# Copy shell script
COPY tools/init.sh /tmp/share/

# Mount volume from host to container
# VOLUME /home/

# Copy my.cnf into container
# COPY conf/my.cnf ~/.my.cnf

# Change owner of all files in the html directory
# /etc/mysql/mariadb.conf.d

EXPOSE 3306

# Keep running the container
CMD ["bash", "/tmp/share/init.sh"]
# CMD ["tail", "-f", "/dev/null"]
