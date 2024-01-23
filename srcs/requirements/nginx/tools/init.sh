#!/bin/bash

apt-get update
apt-get install -y certbot python3-certbot-nginx
certbot run --nginx \
  --non-interactive \
  --agree-tos \
  --no-eff-email \
  --redirect \
  --email ${CERTBOT_EMAIL} \
  --domains ${DOMAIN_NAME}
