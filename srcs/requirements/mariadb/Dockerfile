FROM debian:buster

# install vim and mariadb-server
RUN set -ex; \
	apt-get update \
    && apt-get install -y --no-install-recommends \
		vim \
		mariadb-server \
    && rm -rf /var/lib/apt/lists/* \
# purge and re-create /var/lib/mysql with appropriate ownership
	rm -rf /var/lib/mysql; \
	mkdir -p /var/lib/mysql; \
	chown -R mysql:mysql /var/lib/mysql; \
	chmod 700 /var/lib/mysql; \
# create /var/run/mysqld directory and ensure that /var/run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
	mkdir -p /var/run/mysqld; \
	chown -R mysql:mysql /var/run/mysqld; \
	chmod 777 /var/run/mysqld;

# comment out a few problematic configuration values
RUN set -ex; \
	find /etc/mysql/ -name '*.cnf' -print0 \
		| xargs -0 grep -lZE '^(bind-address\s)' \
		| xargs -rt -0 sed -Ei 's/^(bind-address\s)/#&/';

COPY tools/init.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/init.sh

EXPOSE 3306

ENTRYPOINT ["init.sh"]
