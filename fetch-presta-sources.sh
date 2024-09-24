#!/bin/bash
hash -r
set -eu

PS_FLASHLIGHT_TAG="${1:-nightly}"
CONTAINER_NAME="flashlight-${PS_FLASHLIGHT_TAG}"

tmpdir=$(mktemp -d) || exit 1
destdir="${tmpdir}/PrestaShop"
trap 'rm -rf ${tmpdir}' EXIT TERM

exec 3>&1

{
  exec 1>&2
  docker create --name "$CONTAINER_NAME" "prestashop/prestashop-flashlight:$PS_FLASHLIGHT_TAG"
  docker cp "$CONTAINER_NAME:/var/www/html" "${destdir}"
  docker rm "$CONTAINER_NAME"
}

archive="PrestaShop-${PS_FLASHLIGHT_TAG}.tgz"
tar -C "$tmpdir" -czf "$archive" PrestaShop
readlink -f "$archive" >&3
