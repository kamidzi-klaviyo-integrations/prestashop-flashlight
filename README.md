![PrestaShop Flashlight logo](./assets/prestashop_flashlight_logo.png)

Spin up a PrestaShop testing instance in seconds!

PrestaShop Flashlight is fast: the PrestaShop installation wizard is run at build time, compiling the result to a single database dump. You will get all the content (catalog, orders...) of the usual PrestaShop development seed.

## QuickStart

Following will get you setup with version 1.7.8.11, klaviyo module pre-installed.

1. Copy desired version of klaviyopsautomation module zip archive (from https://addons.prestashop.com/en/newsletter-sms/49837-klaviyo.html) to `modules`
2. ./build-env.sh


## Troubleshooting

- Try running [2] `./build-env.sh` with option `--force-recreate`


## Environment variables

| Variable                   | Description                                                                                                  | Default value                          |
| -------------------------- | ------------------------------------------------------------------------------------------------------------ | -------------------------------------- |
| PS_DOMAIN¹                 | the public domain (and port) to reach your PrestaShop instance                                               | N/A (example: `localhost:8000`)        |
| NGROK_TUNNEL_AUTO_DETECT²  | the ngrok agent base API url, to guess the tunnel domain of your shop                                        | N/A (example `http://ngrok:4040`)      |
| DEBUG_MODE                 | if enabled the Debug mode will be enabled on PrestaShop                                                      | `false`                                |
| DRY_RUN                    | if enabled, the run.sh script will exit without really starting a web server                                 | `false`                                |
| DUMP_ON_RESTART            | if enabled the dump restoration replayed on container restart                                                | `false`                                |
| INIT_ON_RESTART            | if enabled the PS_DOMAIN auto search and dump fix will be replayed on container restart                      | `false`                                |
| INIT_SCRIPTS_DIR           | script directory with executable files to be run prior to PrestaShop startup                                 | `/tmp/init-scripts`                    |
| INIT_SCRIPTS_ON_RESTART    | if enabled custom init scripts will be replayed on container restart                                         | `false`                                |
| INIT_SCRIPTS_USER          | the user running the executable files to be run prior to PrestaShop startup                                  | `www-data`                             |
| INSTALL_MODULES_DIR        | module directory containing zips to be installed with the PrestaShop CLI                                     | empty string (example: `/ps-modules`)  |
| INSTALL_MODULES_ON_RESTART | if enabled zip modules will be reinstalled on container restart                                              | `false`                                |
| MYSQL_DATABASE             | MySQL database name                                                                                          | `prestashop`                           |
| MYSQL_EXTRA_DUMP           | extra SQL dump to be restored in PrestaShop                                                                  | empty string (example: `/tmp/foo.sql`) |
| MYSQL_HOST                 | MySQL host                                                                                                   | `mysql`                                |
| MYSQL_PASSWORD             | MySQL password                                                                                               | `prestashop`                           |
| MYSQL_PORT                 | MySQL server port                                                                                            | `3306`                                 |
| MYSQL_USER                 | MySQL user                                                                                                   | `prestashop`                           |
| ON_INIT_SCRIPT_FAILURE     | if set to `continue`, PrestaShop Flashlight will continue the boot process even if an init script failed     | `fail`                                 |
| ON_INSTALL_MODULES_FAILURE | if set to `continue`, module installation failure will not block the init process                            | `fail`                                 |
| ON_POST_SCRIPT_FAILURE     | if set to `continue`, PrestaShop Flashlight won't exit in case of script failure                             | `fail`                                 |
| POST_SCRIPTS_DIR           | script directory with executable files to be run after the PrestaShop startup                                | `/tmp/post-scripts`                    |
| POST_SCRIPTS_ON_RESTART    | if enabled custom post scripts will be replayed on container restart                                         | `false`                                |
| POST_SCRIPTS_USER          | the user running the executable files to be run after the PrestaShop startup                                 | `www-data`                             |
| PS_FOLDER                  | prestashop sources directory                                                                                 | `/var/www/html`                        |
| PS_PROTOCOL                | if PS_PROTOCOL equals `https` the public URL will be `https://$PS_DOMAIN`                                    | `http` (example: `https`)              |
| SSL_REDIRECT               | if enabled the public URL will be `https://$PS_DOMAIN` (if not using `PS_PROTOCOL`)                          | `false` (example: `true`)              |
| XDEBUG_ENABLED             | if enabled Xdebug will be enabled in PHP. See settings here: `$PHP_INI_DIR/conf.d/docker-php-ext-xdebug.ini` | `false` (example: `true`)              |
| BLACKFIRE_ENABLED          | if enabled Blackfire will be enabled in PHP. | `false` (example: `true`)              |

> Note:
>
> - ¹required (mutually exclusive with `NGROK_TUNNEL_AUTO_DETECT`)
> - ²required (mutually exclusive with `PS_DOMAIN`)

## Back office access information

The default url/credentials to access to PrestaShop's back office defined in [`./assets/hydrate.sh`](./assets/hydrate.sh) and are set to:

| Url      | {PS_DOMAIN}/admin-dev |
| -------- | --------------------- |
| Login    | admin@prestashop.com  |
| Password | prestashop            |

