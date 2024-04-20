#!/bin/bash

apt-get update
apt-get install -y certbot python3-certbot-nginx systemctl cron
certbot run --nginx \
  --non-interactive \
  --agree-tos \
  --no-eff-email \
  --redirect \
  --email ${CERTBOT_EMAIL} \
  --domains ${DOMAIN_NAME}

systemctl start cron && systemctl enable cron

(crontab -l 2>/dev/null; echo "0 0 */50 * * /usr/bin/certbot renew --quiet") | crontab -
