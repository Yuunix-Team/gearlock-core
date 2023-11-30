# GearLock Recovery Project documentation

## Boot process

After mounted system and data, the initramfs first mount GearLock compressed
image to `/gearlock` and then bind mount `/mnt` to `/gearlock/gearroot`, then run
`/gearlock/bin/bootless-chroot gearload` to check and install all packages inside
`gearload` folder.

Afer finnish installing all packages, `/gearlock` then be bind mounted to
`/data/adb/gearlock`, the `gearload` folder then be chmod\'d read-write, then the system
continues booting normally.
