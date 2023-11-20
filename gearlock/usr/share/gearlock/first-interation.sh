#!/bin/bash

[ -e /var/gearlock/initialized ] && exit 0

BUILDPROP=/system/build.prop

prop() { echo -n "${1#*=}"; }
fprop() { grep -E "ro.$1" $BUILDPROP; }
bprop() { prop "$(fprop "build.$1=")"; }

build_bindpkg() {
	TMPDIR=$(tmpdir)
	CURRENT_DIR=$(pwd)

	cd "$TMPDIR"
	"$GEARLIB"/makepkg/genbuild $@

	abuild -Ff

	cd "$CURRENT_DIR"
}

buildver=$(fprop "([a-z]*).version" | grep -v build)

IFS="
"
for ver in $buildver; do
	case $ver in
	ro.bliss.*) OS="Bliss OS $(prop "$ver")" && break ;;
	ro.phoenix.*) OS="Phoenix OS $(prop "$ver")" && break ;;
	ro.primeos.*) OS="Prime OS $(prop "$ver")" && break ;;
	ro.lineage.*) OS="Lineage OS $(prop "$ver")" ;;
	*) OS="AOSP $(bprop "version.release") $(bprop "flavor")" ;;
	esac
done
unset IFS

cp -r /system/lib/modules /system/lib/firmware /usr/lib/

for kernel in /system/lib/modules/*/; do
	build_bindpkg \
		-A "$(busybox arch)" \
		-D "Linux kernel $kernel - $OS" \
		-l "GPL2" \
		-M "$OS" \
		-N "linux-$kernel" \
		-O "$TMPDIR" \
		-v "${kernel%-*}"
done

build_bindpkg \
	-A "$(busybox arch)" \
	-D "Linux firmware - $OS" \
	-l "GPL2 GPL3 custom" \
	-M "$OS" \
	-N "linux-firmware" \
	-O "$TMPDIR" \
	-v "$(date -d "@$(bprop "date.utc")" "+%Y%m%d.${OS// /_}")"

build_bindpkg \
	-A "$(busybox arch)" \
	-D "Android version" \
	-M "$OS" \
	-N "android" \
	-O "$TMPDIR" \
	-v "$(bprop version.release)" \
	-r "$(bprop version.sdk)"

rm -rf /system/lib/modules /system/lib/firmware &&
	mkdir -p /system/lib/modules /system/lib/firmware

mkdir -p /var/gearlock
touch /var/gearlock/initialized
