# get base image
FROM debian:buster

# set necessary env variables
ARG PORT_NUM_GRAFANA

# get curl to download adminer and congiture Nginx Unit
RUN set -ex; \
    apt-get update; \
    apt-get -y install \
    apt-transport-https \
    software-properties-common \
    wget \
    gnupg; \
    wget -q -O - https://packages.grafana.com/gpg.key | apt-key add -; \
    echo "deb https://packages.grafana.com/oss/deb stable main" | tee -a /etc/apt/sources.list.d/grafana.list; \
    apt-get update; \
    apt-get -y install grafana;

# for debugging
RUN set -ex; \
    apt-get update; \
    apt-get -y install vim;

# copy .yml files and shell script
COPY ./conf/mariadb.yml /usr/share/grafana/conf/provisioning/datasources/
COPY ./conf/wp_dashboard.yml /usr/share/grafana/conf/provisioning/dashboards/
COPY ./conf/wp_dashboard.json /var/lib/grafana/dashboards/
COPY ./tools/init_grafana.sh /usr/local/bin/
RUN chmod 777 /usr/local/bin/init_grafana.sh

EXPOSE ${PORT_NUM_GRAFANA}

ENTRYPOINT [ "init_grafana.sh" ]
