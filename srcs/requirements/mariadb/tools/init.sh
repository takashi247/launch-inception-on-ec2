#!/bin/bash

service mysql start

mysql <<MYSQL_SCRIPT
CREATE DATABASE wpdb;
CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'dbpassword';
GRANT ALL ON *.* TO 'root'@'mariadb' IDENTIFIED BY 'dbpassword' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON wpdb.* TO 'wpuser'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

tail -f /dev/null