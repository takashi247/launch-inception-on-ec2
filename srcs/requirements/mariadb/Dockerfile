FROM debian:buster

# Set necessary env variables
ARG MYSQL_ROOT_PASSWORD
ARG MYSQL_USER
ARG MYSQL_DATABASE
ARG MYSQL_PASSWORD

# install necessary packages
RUN set -ex; \
	apt-get update \
    && apt-get install -y --no-install-recommends \
	# to use server-side applications of mariadb
		mariadb-server \
	# to use envsubst
		gettext-base \
	# remove apt-get caches
    && rm -rf /var/lib/apt/lists/* \
# delete and re-create /var/lib/mysql with appropriate ownership
	rm -rf /var/lib/mysql; \
	mkdir -p /var/lib/mysql; \
	chown -R mysql:mysql /var/lib/mysql; \
	chmod 700 /var/lib/mysql; \
# create /var/run/mysqld directory and ensure that /var/run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
	mkdir -p /var/run/mysqld; \
	chown -R mysql:mysql /var/run/mysqld; \
	chmod 777 /var/run/mysqld;

# comment out bind-address configurations in .cnf files
RUN set -ex; \
	find /etc/mysql/ -name '*.cnf' -print0 \
		| xargs -0 grep -lZE '^(bind-address\s)' \
		| xargs -rt -0 sed -Ei 's/^(bind-address\s)/#&/';

# Copy shell script template in tmp directory
COPY tools/init.template /tmp/

# Convert environment variables in template file
RUN envsubst '$$MYSQL_ROOT_PASSWORD$$MYSQL_USER$$MYSQL_DATABASE$$MYSQL_PASSWORD' \
	< /tmp/init.template > /usr/local/bin/init.sh

RUN chmod 777 /usr/local/bin/init.sh

EXPOSE 3306

ENTRYPOINT ["init.sh"]
