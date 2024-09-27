#!/bin/bash
#
hash -r
set -e

BIN="${0%%*/}"

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
  -u, --repo-url url            Specify url to sources repository
  -v, --verbose                 Enable verbose mode
EoF
    exit $ret
}


options=hb:u:v
longoptions=help,branch:,repo-url:,verbose

# Parse options
parsed=$(getopt -o $options --long $longoptions -- "$@")
if [[ $? -ne 0 ]]; then
    usage 2
fi

eval set -- "$parsed"

# Initialize variables
branch=""
repo_url="git@github.com:klaviyo/prestashop_klaviyo.git"
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
        -u|--repo-url)
            repo_url="$2"
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

excluded_files=(
 klaviyopsautomation.php
)

staging_dir="$(mktemp -d)"
dest_dir=modules/klaviyops


set -u

add_to_git_excludes(){
  local files="$@"
  [[ -z "$files" ]] && return 1

  echo "${files}" | tr ' ' '\n' >> "$staging_dir/.git/info/exclude"
}

purge_staging_dir_files(){
  local files="$@"
  [[ -z "$files" ]] && return 1

  for f in "$files"; do
    path="$staging_dir/$f"
    echo "Removing file $path" >&2
    unlink "$path" || true
  done
}

repo_name="${repo_url##*/}" ; repo_name="${repo_name//.git/}"
trap 'rm -rf "$staging_dir"' EXIT TERM


if [[ -z "$branch" ]]; then
  git clone "$repo_url" "$staging_dir" >&2
else
  echo "Cloning branch $branch" >&2
  git clone -b "$branch" "$repo_url" "$staging_dir" >&2
fi

# enumerate translation files
excluded_file+=( $(find "$staging_dir/translations" -type f -iname '*_klaviyopsautomation.php') )

# munge the excludes
add_to_git_excludes "${excluded_files[@]}"

translation_files=( $(find "$staging_dir/translations" -type f -iname '*_klaviyops.php') )

# move the translation files
for file in "${translation_files}"; do
  renamed="${file/_klaviyops.php/.php}"
  echo "Relocating "$file" => "$renamed"" >&2
  add_to_git_excludes "${renamed//$staging_dir\//}"
  mv "$file" "$renamed"
done

purge_staging_dir_files "${excluded_files[@]}"

# overlay the repository files
rsync -axSH "$staging_dir/" "$dest_dir/"
