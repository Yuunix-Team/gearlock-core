#!/bin/bash

[ -e /var/gearlock/initialized ] && exit 0

BUILDPROP=/system/build.prop

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

cp -r /system/lib/modules /system/lib/firmware /usr/lib/

for kernel in /system/lib/modules/*/; do
  mkdir "$GXP_DB/linux-$kernel" || continue
  cat <<EOF >"$GXP_DB/linux-$kernel/info"
NAME=linux-$kernel
VERSION=$kernel
DESC="Linux kernel $kernel - $OS"
ARCH=$(uname -m)
LICENSE="GPL2"
AUTHOR="$OS"
URL=""
PROVIDES=""
DEPENDS=""
EOF
  find "/system/lib/modules/$kernel/" |
    awk -F "/system/lib/modules/$kernel/" '{print $2}' \
      >"$GXP_DB/linux-$kernel/files"
done

mkdir "$GXP_DB/firmware" && {
  cat <<EOF >"$GXP_DB/linux-firmware/info"
NAME=linux-firmware
VERSION=$(date -d "@$(prop "$(fprop "build.date.utc")")" "+%Y%m%d.${OS// /_}")
DESC="Linux firmwares - $OS"
ARCH=$(uname -m)
LICENSE="GPL2 GPL3 custom"
AUTHOR="$OS"
URL=""
PROVIDES=""
DEPENDS=""
EOF
  find "/system/lib/firmware/" |
    awk -F "/system/lib/firmware/" '{print $2}' \
      >"$GXP_DB/linux-firmware/files"
}

rm -rf /system/lib/modules /system/lib/firmware && 
  mkdir -p /system/lib/modules /system/lib/firmware

mkdir -p /var/gearlock
touch /var/gearlock/initialized
