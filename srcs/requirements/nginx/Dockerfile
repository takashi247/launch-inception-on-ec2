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
COPY conf/tnishina-42-fr.conf /etc/nginx/sites-available

# Create simlink in sites-enable and html directory and add DNS setting
RUN ln -s /etc/nginx/sites-available/tnishina-42-fr.conf /etc/nginx/sites-enabled/tnishina-42-fr.conf
	# mkdir -p /var/www/tnishina.42.fr && \
	# cp -rf /var/www/html/* /var/www/tnishina.42.fr

# set daemon off to run nginx in foreground
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

EXPOSE 443

# Change owner of all files in the www directory
RUN chown -R www-data:www-data /var/www

# Keep running the container
ENTRYPOINT [ "render", "/etc/nginx/sites-available/default", "--", "nginx"]
