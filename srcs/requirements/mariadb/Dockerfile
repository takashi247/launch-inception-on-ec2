# vim:set ft=dockerfile:
FROM debian:buster

# add gosu for easy step-down from root
RUN set -ex; \
	apt-get update \
    && apt-get install -y --no-install-recommends \
        gosu \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir /docker-entrypoint-initdb.d

# install mariadb-server
RUN set -ex; \
	apt-get update; \
	apt-get install -y \
		mariadb-server; \
	rm -rf /var/lib/apt/lists/*; \
# purge and re-create /var/lib/mysql with appropriate ownership
	rm -rf /var/lib/mysql; \
	mkdir -p /var/lib/mysql /var/run/mysqld; \
	chown -R mysql:mysql /var/lib/mysql /var/run/mysqld; \
# ensure that /var/run/mysqld (used for socket and lock files) is writable regardless of the UID our mysqld instance ends up having at runtime
	chmod 777 /var/run/mysqld; \
# comment out a few problematic configuration values
	find /etc/mysql/ -name '*.cnf' -print0 \
		| xargs -0 grep -lZE '^(bind-address|log|user\s)' \
		| xargs -rt -0 sed -Ei 's/^(bind-address|log|user\s)/#&/';

COPY tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/docker-entrypoint.sh
ENTRYPOINT ["docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld"]
