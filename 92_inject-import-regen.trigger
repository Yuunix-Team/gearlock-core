#!/bin/sh

find /etc/init/gearlock -type f -exec printf "\nimport /data/adb/gearlock%s\n" {} + >/etc/init/sources.rc
