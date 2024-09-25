#!/bin/bash
#
# Build environment from scratch
hash -r
set -u

PS_FLASHLIGHT_TAG=1.7.8.11

get_hash_file(){
  local hashdir=.hashes
  local filename="$hashdir/$PS_FLASHLIGHT_TAG"
  if [[ -r "$filename" ]]; then
    echo "$filename"
  else
    return 1
  fi
}

filename="$(./fetch-presta-sources.sh $PS_FLASHLIGHT_TAG)"
./check-hashes.sh $PS_FLASHLIGHT_TAG 2>/dev/null
ret=$?
if [[ $ret != 0 ]]; then
    [[ $ret == 1 ]] && { echo "Hash mismatch! Re-hashing archive contents...";}
    tar -xzf "$filename"
    ./make-hashes.sh $PS_FLASHLIGHT_TAG PrestaShop >/dev/null
fi


# Should do a check on the container tag against PS_FLASHLIGHT_TAG
docker compose up "$@"
