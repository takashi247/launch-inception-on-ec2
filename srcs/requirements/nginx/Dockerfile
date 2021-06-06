# Get base image
FROM debian:buster

# Set Entrykit version
ENV ENTRYKIT_VERSION 0.4.0

# Get necessary applications
RUN set -ex; \
	apt-get update; \
	apt-get -y install wget curl vim openssl \
		nginx; \
	# Remove apt-get caches
	rm -rf /var/lib/apt/lists;

# Set working directory
WORKDIR /var/www/html

# Install Entrykit
RUN set -ex; \
	wget https://github.com/progrium/entrykit/releases/download/v${ENTRYKIT_VERSION}/entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz; \
	tar -xvzf entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz; \
	rm entrykit_${ENTRYKIT_VERSION}_Linux_x86_64.tgz; \
	mv entrykit /bin/entrykit; \
	chmod +x /bin/entrykit; \
	entrykit --symlink; \
# Create a self-signed SSL certificate
	openssl req -newkey rsa:2048 \
		-x509 -nodes -days 365 \
		-keyout /etc/ssl/private/example.key \
		-out /etc/ssl/certs/example.crt \
		-subj '/C=JP/ST=Tokyo/L=Roppongi/O=42Tokyo/OU=Student/CN=localhost';

# Copy config file for nginx server
COPY conf/default.tmpl /etc/nginx/sites-available/
COPY conf/default.conf /etc/nginx/conf.d/

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

EXPOSE 443

# Change owner of all files in the html directory
RUN chown -R www-data:www-data .

# Keep running the container
ENTRYPOINT [ "render", "/etc/nginx/sites-available/default", "--", "nginx"]
