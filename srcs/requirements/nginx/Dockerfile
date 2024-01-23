# Get base image
FROM debian:bookworm-slim

# Set necessary environment variables
ARG DOMAIN_NAME
ARG CERT_PATH
ARG CERT_KEY
ARG PORT_NUM_NGINX_HTTP
ARG PORT_NUM_NGINX_HTTPS
ARG CONT_NAME_WORDPRESS
ARG CONT_NAME_ADMINER
ARG CONT_NAME_GRAFANA
ARG PORT_NUM_WORDPRESS
ARG PORT_NUM_ADMINER
ARG PORT_NUM_GRAFANA

# Get necessary applications
RUN set -ex; \
	apt-get update; \
	apt-get -y install \
	# to create SSL certificate
		openssl \
	# to use envsubst
		gettext-base \
	# to run nginx
		nginx; \
	# Remove apt-get caches
	rm -rf /var/lib/apt/lists;

# Create a self-signed SSL certificate
RUN	openssl req -newkey rsa:2048 \
		-x509 -nodes -days 365 \
		-keyout ${CERT_KEY} \
		-out ${CERT_PATH} \
		-subj "/C=JP/ST=Tokyo/L=Roppongi/O=42Tokyo/OU=Student/CN=${DOMAIN_NAME}" ;

# Copy config file for nginx server
COPY conf/default.conf.template /tmp/
COPY conf/mysite.template /tmp/

# Convert environment variables in template file
RUN envsubst '$$DOMAIN_NAME$$CERT_PATH$$CERT_KEY$$PORT_NUM_ADMINER$$CONT_NAME_ADMINER$$PORT_NUM_GRAFANA$$CONT_NAME_GRAFANA' \
	< /tmp/mysite.template > /etc/nginx/sites-available/mysite.conf && \
	envsubst '$$CONT_NAME_WORDPRESS$$PORT_NUM_WORDPRESS' \
	< /tmp/default.conf.template > /etc/nginx/conf.d/default.conf; \
	rm /tmp/*;

# Create simlink in sites-enable and html directory and add DNS setting
RUN ln -s /etc/nginx/sites-available/mysite.conf /etc/nginx/sites-enabled/mysite.conf

# set daemon off to run nginx in foreground
RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# set necessary ports exposed
EXPOSE ${PORT_NUM_NGINX_HTTP} ${PORT_NUM_NGINX_HTTPS}

# Change owner of all files in the www directory
RUN chown -R www-data:www-data /var/www

# Keep running the container
ENTRYPOINT [ "nginx" ]
