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

Builds the environment containers and optionally imports live sources.

Options:
  -h, --help                    Show this help message
  -b, --branch branchname       Specify a target branch [master]
  -F, --foreground              Build in foreground mode [false]
  -f, --force-recreate          Force recreation of containers [false]
  -u, --repo-url                Sources Repository url
  -v, --verbose                 Enable verbose mode
EoF
    exit $ret
}


options=hb:Ffu:v
longoptions=help,branch:,foreground,force-recreate,repo-url:,verbose

# Parse options
parsed=$(getopt -o $options --long $longoptions -- "$@")
if [[ $? -ne 0 ]]; then
    usage 2
fi

eval set -- "$parsed"

# Initialize variables
branch=""
foreground=false
force_recreate=false
verbose=0

# Process options
import_opts_cmdline=""
compose_opts_cmdline="-d"
while true; do
  echo $1
    case "$1" in
        -h|--help)
            usage
            ;;
        -b|--branch)
            branch="$2"
            shift 2
            import_opts_cmdline+=" --branch $branch"
            ;;
        -F|--foreground)
            foreground=true
            shift 1
            compose_opts_cmdline="${compose_opts_cmdline/-d/ }"
            ;;
        -f|--force-recreate)
            force_recreate=true
            shift 1
            compose_opts_cmdline+=" --force-recreate"
            ;;
        -u|--repo-url)
            repo_url="$2"
            shift 2
            import_opts_cmdline+=" --repo-url $repo_url"
            ;;
        -v|--verbose)
            verbose=1
            shift
            ;;
        --)
            shift
            # cosmetics
            import_opts_cmdline="${import_opts_cmdline/ /}"
            compose_opts_cmdline="${compose_opts_cmdline/ /}"
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
./import-sources.sh "$import_opts_cmdline"

# Should do a check on the container tag against PS_FLASHLIGHT_TAG
docker compose up "$compose_opts_cmdline"
