#!/bin/sh

export PATH=/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin

xdir=/usr/share/gearlock/extensions/

for i in "$@"; do
case "$i" in
*.zip) /usr/lib/gearlock/compat/flashablezip/install "$i" ;;
*.gxp) /usr/lib/gearlock/compat/gearlockgxp/install "$i" ;;
esac
done

mkinitfs -a
