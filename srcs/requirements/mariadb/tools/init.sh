#!/bin/bash

service mysql start

mysql <<MYSQL_SCRIPT
CREATE DATABASE wpdb;
CREATE USER 'wpuser'@'localhost' identified by 'dbpassword';
GRANT ALL PRIVILEGES ON wpdb.* TO 'wpuser'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

tail -f /dev/null