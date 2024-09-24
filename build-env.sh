#!/bin/bash
#
# Build environment from scratch
hash -r
set -eu

PS_FLASHLIGHT_TAG=1.7.8.11


filename="$(./fetch-presta-sources.sh $PS_FLASHLIGHT_TAG)"
tar -xzf "$filename"
# Should do a check on the container tag against PS_FLASHLIGHT_TAG
docker-compose up "$@"
