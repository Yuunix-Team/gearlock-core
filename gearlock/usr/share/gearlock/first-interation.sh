#!/bin/bash

[ -e /var/gearlock/initialized ] && exit 0

BUILDPROP=/system/build.prop

set_cmdline() {
	set -- $(cat /proc/cmdline)
	for arg in "$@"; do
		case "$arg" in
		ROOT=* | SRC=* | SYSTEM=* | DATA=* | GEARLOCK=*) ;;
		*=*) eval "$arg" ;;
		esac
	done
}

prop() { echo -n "${1#*=}"; }
fprop() { grep -E "ro.$1" $BUILDPROP; }
bprop() { prop "$(fprop "build.$1=")"; }

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

rm -rf /root/packages/*/*/*.apk

kernel=$(uname -r)
"$GEARLIB"/makepkg/bindpkg \
	modules/"$kernel" \
	"/boot/$BOOT_IMAGE" "$SRCDIR/$BOOT_IMAGE" \
	-A "$(busybox arch)" \
	-D "Linux kernel $kernel - $OS" \
	-l "GPL2" \
	-M "$OS" \
	-N "linux-$kernel" \
	-O "$TMPDIR" \
	-v "${kernel%-*}"

"$GEARLIB"/makepkg/bindpkg \
	firmware \
	-A "$(busybox arch)" \
	-D "Linux firmware - $OS" \
	-l "GPL2 GPL3 custom" \
	-M "$OS" \
	-N "linux-firmware" \
	-O "$TMPDIR" \
	-v "$(date -d "@$(bprop "date.utc")" "+%Y%m%d.${OS// /_}")"

apk add /gearload/*.apk /root/packages/*/*/*.apk
rm -rf /root/packages/*/*/*.apk

# for safety, don't
# rm -rf /system/lib/modules /system/lib/firmware &&
# 	mkdir -p /system/lib/modules /system/lib/firmware

mkdir -p /var/gearlock
touch /var/gearlock/initialized
