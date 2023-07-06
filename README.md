![PrestaShop Flashlight logo](./assets/prestashop_flashlight_logo.png)

Spin a Prestashop testing instance in seconds!

> **⚠️ Disclaimer**: the following tool is provided in the solely purpose of bootstraping a PrestaShop testing environment. <br>If you look for a production grade image, please refer to https://github.com/PrestaShop/docker.

> **Note**: no MySQL server is shipped in the resulting image, you have to provide your own instance for the backup to be dumped during the first connection.

Compatible with these architecture:

- linux/amd64 (akka `x86_64`)
- linux/arm64/v8 (akka `arm64`)

The resulting image is based on this tech stack:

- An [Alpine](https://alpine-linux.org) linux image
- An [Nginx](https://nginx.com) server

## How fast is it?

On a Mac M1 (_linux/arm64_) computer:

```
❯ docker compose up -d
[+] Building 0.0s (0/0)
[+] Running 3/3
 ✔ Container phpmyadmin  Running            0.0s
 ✔ Container mysql       Healthy           10.8s
 ✔ Container prestashop  Started           11.1s
```

VS the official production image (_linux/amd64_ only) with `AUTO_INSTALL=1`: 2mn 15s.

## Where do I find pre-built images?

Here: https://hub.docker.com/r/prestashop/flashlight

## Build

```sh
PS_VERSION=8.1.0 ./build.sh
```

## Use

Start the environment

```sh
cp .env.dist .env
edit .env
docker compose up
```

Add init scripts

```yaml
services:
  prestashop:
    image: prestashop/flashlight:8.1.0-8.1
    volumes:
      - ./init-scripts:/tmp/init-scripts:ro
```

## Container environment variables

- **`PS_DOMAIN`**
  - Description: the public domain (and port) to reach your PrestaShop instance
  - Mandatory if you do not use `NGROK_TUNNEL_AUTO_DETECT`
  - Example: `localhost:8000`
- **`NGROK_TUNNEL_AUTO_DETECT`**
  - Description: the ngrok agent base API url, to guess the tunnel domain of your shop
  - Mandatory if you do not use `PS_DOMAIN`
  - Example: `http://ngrok:4040`
- **`SSL_REDIRECT`**
  - If set to `true` PrestaShop will be told to redirect all inbound traffic to https://$PS_DOMAIN
  - Default to `false` (or automatically guessed if using NGROK_TUNNEL_AUTO_DETECT)
- **`DEBUG_MODE`**
  - If set to `true` the Debug mode will be enabled on PrestaShop
  - Default to `false`
- **`INSTALL_MODULES_DIR`**
  - A module directory containing zips to be installed with the PrestaShop CLI
  - Example: `/ps-modules`
- **`INIT_ON_RESTART`**
  - If set to `true` the PS_DOMAIN auto search and dump fix will be replayed on container restart
  - Default to `false`
- **`DUMP_ON_RESTART`**
  - If set to `true` the dump restoration replayed on container restart
  - Default to `false`
- **`INSTALL_MODULES_ON_RESTART`**
  - If set to `true` zip modules will be reinstalled on container restart
  - Default to `false`
- **`INIT_SCRIPTS_ON_RESTART`**
  - If set to `true` custom init scripts will be replayed on container restart
  - Default to `false`

## Credits

- https://github.com/PrestaShop/PrestaShop
- https://github.com/PrestaShop/performance-project
- https://github.com/jokesterfr/docker-prestashop
