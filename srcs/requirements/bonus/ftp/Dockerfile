# get base image
FROM debian:buster

# set necessary env variable
ARG PORT_NUM_FTP1
ARG PORT_NUM_FTP2
ARG PORT_NUM_FTP3
ARG CERT_PATH
ARG CERT_KEY
ARG DOMAIN_NAME
ARG TINI_VERSION

# Get necessary applications
RUN set -ex; \
	apt-get update; \
	apt-get -y install \
    # install vsftpd for setting up ftp server
        vsftpd \
	# to create SSL certificate
        openssl \
	# to use envsubst
		gettext-base \
    # install db-util to update user database for ftp server
        db-util; \
	# Remove apt-get caches
	rm -rf /var/lib/apt/lists;

# Create a self-signed SSL certificate
RUN	openssl req -newkey rsa:2048 \
		-x509 -nodes -days 365 \
		-keyout ${CERT_KEY} \
		-out ${CERT_PATH} \
		-subj "/C=JP/ST=Tokyo/L=Roppongi/O=42Tokyo/OU=Student/CN=${DOMAIN_NAME}" ;

COPY ./conf/vsftpd.conf.template /tmp/
COPY ./conf/vsftpd_virtual /etc/pam.d/

RUN mkdir -p /etc/vsftpd && \
    envsubst '$$PORT_NUM_FTP3$$CERT_KEY$$CERT_PATH' \
    < /tmp/vsftpd.conf.template > /etc/vsftpd/vsftpd.conf && \
    rm /tmp/*;

COPY ./tools/init_vsftpd.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/init_vsftpd.sh

EXPOSE ${PORT_NUM_FTP1}
EXPOSE ${PORT_NUM_FTP2}
EXPOSE ${PORT_NUM_FTP3}

# install and run tini to avoid PID 1 issue
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

CMD [ "init_vsftpd.sh" ]