#!/bin/bash
hash -r
set -eux
echo Enabling Webservice and Enabling CGI mode

# TODO - can have duplicates
mysql -u "$MYSQL_USER" --password="$MYSQL_PASSWORD" --host="$MYSQL_HOST" "$MYSQL_DATABASE" <<EoF
INSERT INTO ps_configuration (name, value, date_add, date_upd) VALUES
  ('PS_WEBSERVICE', 1, NOW(), NOW()),
  ('PS_WEBSERVICE_CGI_HOST', 1, NOW(), NOW())
EoF
