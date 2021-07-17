# get base image
FROM debian:buster

# set necessary env variable
ARG PORT_NUM_FTP1
ARG PORT_NUM_FTP2

# Get necessary applications
RUN set -ex; \
	apt-get update && apt-get upgrade; \
	apt-get -y install \
    # install vsftpd for setting up ftp server
    vsftpd \
    # install db-util to update user database for ftp server
    db-util; \
	# Remove apt-get caches
	rm -rf /var/lib/apt/lists;

COPY ./tools/init_vsftpd.sh /usr/local/bin/
COPY ./conf/vsftpd.conf /etc/vsftpd/
COPY ./conf/vsftpd_virtual /etc/pam.d/

RUN chmod 777 /usr/local/bin/init_vsftpd.sh

EXPOSE ${PORT_NUM_FTP1} ${PORT_NUM_FTP2}

CMD [ "init_vsftpd.sh" ]