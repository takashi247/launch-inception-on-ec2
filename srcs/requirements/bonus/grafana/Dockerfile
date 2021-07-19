# get base image
FROM debian:buster

# set necessary env variables
ARG PORT_NUM_GRAFANA
ARG CONT_NAME_MARIADB
ARG PORT_NUM_MARIADB
ARG MYSQL_USER
ARG MYSQL_PASSWORD
ARG MYSQL_DATABASE
ARG GRAFANA_DATASOURCES_NAME
ARG GRAFANA_DASHBOARD_NAME
ARG TINI_VERSION

# install required applications incl. grafana
RUN set -ex; \
    apt-get update; \
    apt-get -y install \
        wget \
    # to use envsubst
        gettext-base;

# install grafana from tar file
RUN set -ex; \
	wget https://dl.grafana.com/oss/release/grafana-7.4.5.linux-amd64.tar.gz; \
	tar -zxvf grafana-7.4.5.linux-amd64.tar.gz; \
	rm grafana-7.4.5.linux-amd64.tar.gz; \
	mv grafana-7.4.5 grafana; \
	mv grafana/ /usr/share/

# copy .yml files
COPY ./conf/mariadb.yml.template /tmp/
COPY ./conf/wp_dashboard.yml.template /tmp/
COPY ./conf/wp_dashboard.json.template /tmp/

# update env variables in .yml files
RUN envsubst '$$CONT_NAME_MARIADB$$PORT_NUM_MARIADB$$MYSQL_USER$$MYSQL_PASSWORD$$MYSQL_DATABASE$$GRAFANA_DATASOURCES_NAME' \
    < /tmp/mariadb.yml.template > /usr/share/grafana/conf/provisioning/datasources/mariadb.yml; \
    envsubst '$$GRAFANA_DASHBOARD_NAME' \
    < /tmp/wp_dashboard.yml.template > /usr/share/grafana/conf/provisioning/dashboards/wp_dashboard.yml; \
    mkdir -p /var/lib/grafana/dashboards && \
    envsubst '$$GRAFANA_DATASOURCES_NAME' \
    < /tmp/wp_dashboard.json.template > /var/lib/grafana/dashboards/wp_dashboard.json; \
    rm /tmp/*;

# copy shell script and modify permission
COPY ./tools/init_grafana.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/init_grafana.sh

EXPOSE ${PORT_NUM_GRAFANA}

# install and run tini to avoid PID 1 issue
ADD https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini /tini
RUN chmod +x /tini
ENTRYPOINT ["/tini", "--"]

CMD [ "init_grafana.sh" ]
