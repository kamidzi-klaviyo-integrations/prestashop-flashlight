#!/bin/bash
#
# Checks the file hashes
#
hash -r
set -e

hashdir=.hashes
ver=${1}

usage(){
  BIN="${0##*/}"
  declare -i ret
  local ret=${1:-0}

  if [[ $ret == 0 ]]; then
    exec 3>&1
  else
    exec 3>&2
  fi

  cat >&3 <<EoF
$BIN version
EoF
  exec 3>&-
  exit $ret
}

hashdir=.hashes
ver=${1}

if [[ -z "$ver" ]]; then
  usage 1
fi

set -u

get_hash_file(){
  local filename="$hashdir/$ver"
  if [[ -r "$filename" ]]; then
    echo "$filename"
  else
    echo "Unknown version $ver" >&2
    return 20
  fi
}

hashfile="$(get_hash_file)"
shasum --status -c "$hashfile"
