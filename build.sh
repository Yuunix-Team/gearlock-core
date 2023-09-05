#!/bin/bash

mkdir -p build

while read -r file; do
  header=$(head -1 "$file")
  target=build/${file#gearlock}

  target_dir=${target%/*}
  [ -d "$target_dir" ] || mkdir -p "$target_dir"

  case "$header" in
  \#\!/*)
    [ "${DEBUG#0}" ] &&
      cp "$file" "$target" ||
      shfmt -mn "$file" >"$target" ||
      shfmt -mn -ln=mksh "$file" >"$target"
    chmod +x "$target"
    ;;
  *) cp "$file" "$target" ;;
  esac

done <<<"$(find gearlock -type f)"
