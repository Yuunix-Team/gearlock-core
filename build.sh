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
			cp -a "$file" "$target" ||
			shfmt -mn "$file" >"$target" ||
			shfmt -mn -ln=mksh "$file" >"$target"
		chmod +x "$target"
		;;
	*) cp "$file" "$target" ;;
	esac

done <<<"$(find gearlock -type f)"

while read -r file; do
	target=build/${file#gearlock}

	target_dir=${target%/*}
	[ -d "$target_dir" ] || mkdir -p "$target_dir"

	cp -a "$(readlink -f "$file")" "$target"
done <<<"$(find gearlock -type l)"
