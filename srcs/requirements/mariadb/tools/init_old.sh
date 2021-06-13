#!/bin/bash

set -e

# fix permissions and ownershp of /var/lib/mysql
mkdir -p -m 700 /var/lib/mysql
chown -R mysql:mysql /var/lib/mysql

# fix permissions and ownership of /run/mysqld
mkdir -p -m 0755 /run/mysqld
chown -R mysql:root /run/mysqld

# tail -f /dev/null

# initialize mariadb data directory
if [ ! -d /var/lib/mysql/mysql ]; then
    echo "Installing database..."
    mysql_install_db --user=mysql >/dev/null 2>&1

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
fi

service mysql start

mysql -uroot -e \
    "CREATE DATABASE wpdb; \
    CREATE USER 'wpuser'@'mariadb' IDENTIFIED BY 'dbpassword'; \
    GRANT ALL ON *.* TO 'root'@'mariadb' IDENTIFIED BY 'dbpassword' WITH GRANT OPTION; \
    GRANT ALL PRIVILEGES ON wpdb.* TO 'wpuser'@'mariadb'; \
    FLUSH PRIVILEGES;"

# /usr/bin/mysqladmin shutdown
/usr/bin/mysqladmin --defaults-file=/etc/my.cnf shutdown

# exec mysqld
exec /usr/bin/mysqld_safe


# service mysql start

# mysqld_safe