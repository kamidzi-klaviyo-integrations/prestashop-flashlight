#!/bin/bash
#
# Creates the file hashes
#
hash -r
set -e

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
$BIN version directory
EoF
  exec 3>&-
  exit $ret
}

hashdir=.hashes
ver=${1}
directory=${2}

if [[ -z "$ver" ]] || [[ -z "$directory" ]]; then
  usage 1
fi

set -u

filename="$hashdir/$ver"
dirpath=${directory%/*}

find "$dirpath" -type f | sort | tr '\n' '\0' | xargs -0 sha1sum | tee "$filename"
