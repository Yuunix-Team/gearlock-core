#!/bin/bash

export PATH=/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin

[ -e /var/gearlock/initialized ] && exit 0

ARCH=$(busybox arch)
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

fld_size() { du -sk "/system/lib/$1/" | awk '{print $1}'; }
bindpkg() {
	TYPE=$1
	mkdir -p "$TMPDIR/usr/lib/$TYPE"
	cp -t "$TMPDIR/$(dirname "usr/lib/$TYPE")" -a "/system/lib/$TYPE"

	case "$TYPE" in
	modules/*) for kernel in "$@"; do
		shift
		[ -f "/boot/$kernel" ] && cp "/boot/$kernel" "$TMPDIR/usr/lib/$TYPE/vmlinuz" && break
	done ;;
	esac

	MAKEFILE="
build:
	echo 'Creating package...'

install:
	cp -t \$(DESTDIR)/ -a ./usr 
"
}

export -f bindpkg

if [ "$(ls -A /system/lib/modules/)" ]; then
	move() { bindpkg modules/"$kernel" "kernel-su" "kernel"; }
	export -f move
	kernel=$(basename /system/lib/modules/*)
	"$GEARLIB"/makepkg/genbuild \
		-A "$ARCH" \
		-D "Linux kernel $kernel - $OS" \
		-l "GPL2" \
		-M "$OS <root@127.0.0.1>" \
		-N "linux-$kernel" \
		-o "!strip !tracedeps !check" \
		-v "${kernel%%-*}" \
		-S "$(fld_size modules)" \
		-B "$MAKEFILE"
fi

if [ "$(ls -A /system/lib/firmware/)" ]; then
	move() { bindpkg firmware; }
	export -f move
	"$GEARLIB"/makepkg/genbuild \
		-A "$ARCH" \
		-D "Linux firmware - $OS" \
		-l "GPL2 GPL3 custom" \
		-M "$OS <root@127.0.0.1>" \
		-N "linux-firmware" \
		-o "!strip !tracedeps !check" \
		-v "$(date -d "@$(bprop "date.utc")" "+%Y%m%d")" \
		-S "$(fld_size firmware)" \
		-B "$MAKEFILE"
fi

mkdir -p /var/gearlock
touch /var/gearlock/initialized
