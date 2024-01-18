#!/bin/bash

# install plugin using cli
/usr/share/grafana/bin/grafana-cli plugins install grafana-piechart-panel

# move Grafana's working directory
cd /usr/share/grafana

# update some config values using env variables
export GF_PATHS_PLUGINS=/var/lib/grafana/plugins

# start grafana server
./bin/grafana-server --config /usr/share/grafana/conf/defaults.ini