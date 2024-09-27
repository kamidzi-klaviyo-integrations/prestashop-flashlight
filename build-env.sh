#!/bin/bash
#
# Build environment from scratch
hash -r
set -u

BIN="${0%%*/}"
PS_FLASHLIGHT_TAG=1.7.8.11

# Function to display usage
usage() {
  declare -i ret
  local ret=${1:-0}

  if [[ $ret == 0 ]]; then
    exec 3>&1
  else
    exec 3>&2
  fi

  cat <<EoF
Usage: $BIN [options]
Options:
  -h, --help                    Show this help message
  -b, --branch branchname       Specify a target branch
  -v, --verbose                 Enable verbose mode
EoF
    exit $ret
}


options=hb:v
longoptions=help,branch:,verbose

# Parse options
parsed=$(getopt -o $options --long $longoptions -- "$@")
if [[ $? -ne 0 ]]; then
    usage 2
fi

eval set -- "$parsed"

# Initialize variables
branch=""
verbose=0

# Process options
while true; do
    case "$1" in
        -h|--help)
            usage
            ;;
        -b|--branch)
            branch="$2"
            shift 2
            ;;
        -v|--verbose)
            verbose=1
            shift
            ;;
        --)
            shift
            break
            ;;
        *)
            usage 1
            ;;
    esac
done

filename="$(./fetch-presta-sources.sh $PS_FLASHLIGHT_TAG)"
./check-hashes.sh $PS_FLASHLIGHT_TAG 2>/dev/null
ret=$?
if [[ $ret != 0 ]]; then
    [[ $ret == 1 ]] && { echo "Hash mismatch! Re-hashing archive contents for $filename...";}
    tar -xzf "$filename"
    ./make-hashes.sh $PS_FLASHLIGHT_TAG PrestaShop >/dev/null
fi

# import the sources
if [[ ! -z "$branch" ]]; then
  ./import-sources.sh --branch "$branch"
else
  ./import-sources.sh
fi

# Should do a check on the container tag against PS_FLASHLIGHT_TAG
docker compose up "$@"
