#!/bin/bash
#
hash -r
set -e

excluded_files=(
 klaviyopsautomation.php
)

staging_dir="$(mktemp -d)"
dest_dir=modules/klaviyops

url="${1:-git@github.com:klaviyo/prestashop_klaviyo.git}"
branch="${2:-master}"

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
    unlink "$path"
  done
}

repo_name="${url##*/}" ; repo_name="${repo_name//.git/}"
trap 'rm -rf "$staging_dir"' EXIT TERM 


git clone -b "$branch" "$url" "$staging_dir" >&2
# enumerate translation files
excluded_file+=( $(find "$staging_dir/translations" -type f -iname '*_klaviyopsautomation.php') )

# munge the excludes
#echo "${excluded_files[@]}" | tr ' ' '\n' >> "$staging_dir/.git/info/exclude"
add_to_git_excludes "${excluded_files[@]}"

translation_files=( $(find "$staging_dir/translations" -type f -iname '*_klaviyops.php') )
# move the translation files
for file in "${translation_files}"; do
  renamed="${file/_klaviyops.php/.php}"
  echo "Relocating "$file" => "$renamed"" >&2
  mv "$file" "$renamed"
done

purge_staging_dir_files "${excluded_files[@]}"

#?# remove excluded files
#?for f in "${excluded_files[@]}"; do
#?  path="$staging_dir/$f"
#?  echo "Removing file $path" >&2 
#?  unlink "$path"
#?done

# overlay the repository files
rsync -axSH "$staging_dir/" "$dest_dir/"
