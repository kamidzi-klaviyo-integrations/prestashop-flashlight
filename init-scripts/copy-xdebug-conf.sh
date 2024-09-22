#!/bin/bash
hash -r
set -eux

# need to fix perms
id -un
ls -ld /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
cp -f /config/xdebug.ini /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
