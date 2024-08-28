#!/bin/bash
#
set -x
echo Enabling Webservice

mysql -u prestashop -pprestashop prestashop <<EoF
INSERT INTO ps_configuration (name, value, date_add, date_upd) VALUES ('PS_WEBSERVICE', 1, NOW(), NOW())
EoF
