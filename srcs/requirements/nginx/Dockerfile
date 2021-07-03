# Get base image
FROM debian:buster

# Set necessary environment variables
ARG DOMAIN_NAME
ARG CERT_PATH
ARG CERT_KEY

# Get necessary applications
RUN set -ex; \
	apt-get update; \
	apt-get -y install wget curl vim openssl \
		gettext-base \
		nginx; \
	# Remove apt-get caches
	rm -rf /var/lib/apt/lists;

# Set working directory
WORKDIR /var/www/html

# Create a self-signed SSL certificate
RUN	openssl req -newkey rsa:2048 \
		-x509 -nodes -days 365 \
		-keyout ${CERT_KEY} \
		-out ${CERT_PATH} \
		-subj "/C=JP/ST=Tokyo/L=Roppongi/O=42Tokyo/OU=Student/CN=${DOMAIN_NAME}" ;

# Copy config file for nginx server
COPY conf/default.conf /etc/nginx/conf.d/
COPY conf/mysite.template /etc/nginx/sites-available

# Convert environment variables in template file
RUN envsubst '$$DOMAIN_NAME$$CERT_PATH$$CERT_KEY' \
	< /etc/nginx/sites-available/mysite.template > /etc/nginx/sites-available/mysite.conf

# Create simlink in sites-enable and html directory and add DNS setting
RUN ln -s /etc/nginx/sites-available/mysite.conf /etc/nginx/sites-enabled/mysite.conf

# set daemon off to run nginx in foreground
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

EXPOSE 443

# Change owner of all files in the www directory
RUN chown -R www-data:www-data /var/www

# Keep running the container
ENTRYPOINT [ "nginx" ]
