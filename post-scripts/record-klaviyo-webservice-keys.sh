#!/bin/sh
set -exu

# Eventually install the klaviyo modules
if [ -d "$WEBSERVICE_KEYS_DIR" ]; then
   echo "--> Recording webservice keys to $WEBSERVICE_KEYS_DIR/keys..."
   mysql -u "$MYSQL_USER" --password="$MYSQL_PASSWORD" --host="$MYSQL_HOST" "$MYSQL_DATABASE" <<EoF
select \`key\`, description, active from ps_webservice_account
EoF > "$WEBSERVICE_KEYS_DIR/keys"
fi
