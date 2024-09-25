#!/bin/bash
hash -r
set -eu

PS_FLASHLIGHT_TAG="${1:-nightly}"
CONTAINER_NAME="flashlight-${PS_FLASHLIGHT_TAG}"


exec 3>&1

archive="PrestaShop-${PS_FLASHLIGHT_TAG}.tgz"

{
  exec 1>&2
  
  # should verify actual checksums
  if [ -r "$archive" ]; then
    echo "$archive" already exists. Skipping download...
  else
    tmpdir=$(mktemp -d) || exit 1
    destdir="${tmpdir}/PrestaShop"
    trap 'rm -rf ${tmpdir}' EXIT TERM

    docker create --name "$CONTAINER_NAME" "prestashop/prestashop-flashlight:$PS_FLASHLIGHT_TAG"
    docker cp "$CONTAINER_NAME:/var/www/html" "${destdir}"
    docker rm "$CONTAINER_NAME"
    tar -C "$tmpdir" -czf "$archive" PrestaShop
  fi
}
readlink -f "$archive" >&3
exec 3>&-


