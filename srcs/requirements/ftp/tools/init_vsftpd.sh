#!/bin/bash

# Create a file that contains new ftp user info
echo -e "${FTP_USER}\n${FTP_PASS}" > /etc/vsftpd/virtual_users.txt
# Load user data from the file create above into db database file
# -T: allow non-Berkeley DB applications to easily load text files into database
# -t type: specify underlying access method
# -f: Read from specified input file, not from stdin
db_load -T -t hash -f /etc/vsftpd/virtual_users.txt /etc/vsftpd/virtual_users.db

mkdir -p /var/run/vsftpd/empty

# Set passive mode parameters:
echo "pasv_address=${DOMAIN_NAME}" >> /etc/vsftpd/vsftpd.conf

# Run vsftpd:
vsftpd /etc/vsftpd/vsftpd.conf
