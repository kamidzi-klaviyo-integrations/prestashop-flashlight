#!/bin/sh
set -eu

export BLACKFIRE_ENABLED="${BLACKFIRE_ENABLED:-false}"
export DEBUG_MODE="${DEBUG_MODE:-true}"
export DRY_RUN="${DRY_RUN:-false}"
export DUMP_ON_RESTART="${DUMP_ON_RESTART:-false}"
export INIT_ON_RESTART="${INIT_ON_RESTART:-false}"
export INIT_SCRIPTS_DIR="${INIT_SCRIPTS_DIR:-/tmp/init-scripts/}"
export INIT_SCRIPTS_ON_RESTART="${INIT_SCRIPTS_ON_RESTART:-false}"
export INIT_SCRIPTS_USER="${INIT_SCRIPTS_USER:-www-data}"
export INSTALL_MODULES_DIR="${INSTALL_MODULES_DIR:-}"
export INSTALL_MODULES_ON_RESTART="${INSTALL_MODULES_ON_RESTART:-false}"
export MYSQL_VERSION="${MYSQL_VERSION:-5.7}"
export ON_INIT_SCRIPT_FAILURE="${ON_INIT_SCRIPT_FAILURE:-fail}"
export ON_INSTALL_MODULES_FAILURE="${ON_INSTALL_MODULES_FAILURE:-fail}"
export POST_SCRIPTS_DIR="${POST_SCRIPTS_DIR:-/tmp/post-scripts/}"
export POST_SCRIPTS_ON_RESTART="${POST_SCRIPTS_ON_RESTART:-false}"
export POST_SCRIPTS_USER="${POST_SCRIPTS_USER:-www-data}"
export PS_PROTOCOL="${PS_PROTOCOL:-http}"
export SSL_REDIRECT="${SSL_REDIRECT:-false}"
export XDEBUG_ENABLED="${XDEBUG_ENABLED:-true}"

INIT_LOCK=/tmp/flashlight-init.lock
DUMP_LOCK=/tmp/flashlight-dump.lock
MODULES_INSTALLED_LOCK=/tmp/flashlight-modules-installed.lock
INIT_SCRIPTS_LOCK=/tmp/flashlight-init-scripts.lock
POST_SCRIPTS_LOCK=/tmp/flashlight-post-scripts.lock

# Runs everything as www-data
run_user () {
  sudo -g www-data -u www-data -- "$@"
}

# Eventually install some modules
if [ ! -f $MODULES_INSTALLED_LOCK ] || [ "$INSTALL_MODULES_ON_RESTART" = "true" ]; then
  if [ -d "$KLAVIYO_INSTALL_MODULES_DIR" ]; then
    if [ -f "$PS_FOLDER/bin/console" ]; then
      for file in "$KLAVIYO_INSTALL_MODULES_DIR"/*.zip; do
        module=$(unzip -l "$file" | awk 'NR==4{print $4}' | sed 's/\/$//' | tr "-" "\n" | head -n 1)
        echo "--> Unzipping and installing $module from $file..."
        rm -rf "/var/www/html/modules/${module:-something-at-least}"
        run_user unzip -qq "$file" -d /var/www/html/modules
        if [ "$ON_INSTALL_MODULES_FAILURE" = "continue" ]; then
          (run_user php -d memory_limit=-1 bin/console prestashop:module --no-interaction install "$module") || { echo "x module installation failed. Skipping."; }
        else
          (run_user php -d memory_limit=-1 bin/console prestashop:module --no-interaction install "$module") || { echo "x module installation failed. Sleep and exit."; sleep 10; exit 6; }
        fi
      done;
    else
      echo "Auto-installing modules with PrestaShop v1.6 is not yet supported";
    fi
  fi
  touch $MODULES_INSTALLED_LOCK
else
  echo "* Module installation already performed (see INSTALL_MODULES_ON_RESTART)"
fi
