#!/bin/bash
#
echo Enabling Webservice
php bin/console prestashop:config --value 1 set PS_WEBSERVICE
