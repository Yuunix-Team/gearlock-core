#!/bin/bash

mkdir -p build

while read -r file; do
  header=$(head -1 "$file")
  target=build/${file#src}

  target_dir=${target%/*}
  [ -d "$target_dir" ] || mkdir -p "$target_dir"

  case "$header" in
  \#\!/*)
    ./tools/minifier/minifier.sh --shell="${header#*\!}" --output="$target" "$file"
    chmod +x "$target"
    ;;
  *) cp "$file" "$target" ;;
  esac

done <<<"$(find src -type f)"
