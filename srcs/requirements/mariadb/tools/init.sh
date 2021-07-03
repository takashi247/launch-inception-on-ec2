#!/bin/bash

# set error exit option
set -e

# initialize mariadb data directory
if [ ! -d /var/lib/mysql/mysql ]; then
    echo "Installing database..."
    mysql_install_db --user=mysql --datadir="/var/lib/mysql" --rpm --auth-root-authentication-method=normal >/dev/null 2>&1

    # start MariaDB server
    echo "Starting MariaDB server..."
    /usr/bin/mysqld_safe >/dev/null 2>&1 &

    # wait for mariadb server to start (max 30 seconds)
    timeout=30
    echo -n "Waiting for database server to accept connections"
    while ! /usr/bin/mysqladmin -u root status >/dev/null 2>&1
    do
        timeout=$(($timeout - 1))
        if [ $timeout -eq 0 ]; then
            echo -e "\nCould not connect to database server. Aborting..."
            exit 1
        fi
        echo -n "."
        sleep 1
    done
    echo

    mysql -uroot -e \
    "CREATE USER 'root'@'%' IDENTIFIED BY 'dbpassword'; \
    GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY 'dbpassword' WITH GRANT OPTION; \
    SET PASSWORD FOR 'root'@'localhost' = PASSWORD('dbpassword'); \
    GRANT ALL ON *.* TO 'root'@'localhost' WITH GRANT OPTION; \
    CREATE DATABASE IF NOT EXISTS wpdb; \
    CREATE USER 'wpuser'@'%' IDENTIFIED BY 'dbpassword'; \
    SET PASSWORD FOR 'wpuser'@'%' = PASSWORD('dbpassword'); \
    GRANT ALL PRIVILEGES ON wpdb.* TO 'wpuser'@'%'; \
    CREATE USER 'wpuser'@'localhost' IDENTIFIED BY 'dbpassword'; \
    SET PASSWORD FOR 'wpuser'@'localhost' = PASSWORD('dbpassword'); \
    GRANT ALL PRIVILEGES ON wpdb.* TO 'wpuser'@'localhost'; \
    FLUSH PRIVILEGES;"

    /usr/bin/mysqladmin --password=dbpassword shutdown
fi

# exec mysqld
exec mysqld --user=mysql
