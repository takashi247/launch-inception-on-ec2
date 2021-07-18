#!/bin/bash

# install plugin using cli
/usr/share/grafana/bin/grafana-cli plugins install grafana-piechart-panel


cd /usr/share/grafana
export GF_PATHS_PLUGINS=/var/lib/grafana/plugins
export GF_SECURITY_ADMIN_USER=gf_admin
export GF_SECURITY_ADMIN_PASSWORD=gf_admin_pass
grafana-server --config /usr/share/grafana/conf/defaults.ini