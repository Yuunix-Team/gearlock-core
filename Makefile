
DESTDIR := /
DEBUG := 0

DIRLIST := etc \
	etc/grub.d \
	etc/apk \
	etc/apk/commit_hooks.d \
	etc/init \
	etc/init/gearlock \
	usr \
	usr/bin \
	usr/lib \
	usr/lib/gearlock \
	usr/lib/gearlock/sysup \
	usr/lib/gearlock/compat \
	usr/lib/gearlock/compat/flashablezip \
	usr/lib/gearlock/compat/flashablezip/ksu \
	usr/lib/gearlock/compat/flashablezip/magisk \
	usr/lib/gearlock/compat/gearlockgxp \
	usr/lib/gearlock/makepkg \
	usr/share \
	usr/share/gearlock \
	usr/share/gearlock/docs \
	usr/share/gearlock/examples \
	usr/share/gearlock/mkinitfs \
	usr/share/gearlock/mkinitfs/hooks \
	usr/share/gearlock/mkinitfs/installs \
	usr/share/gearlock/mkinitfs/templates \
	usr/share/gearlock/extension

FILELIST := etc/grub.d/10_android \
	etc/gearlock.conf \
	etc/apk/commit_hooks.d/00_gearlock-compatibility \
	etc/mkinitfs.conf \
	etc/init/gearlock/init.rc \
	etc/init/gearlock/sources.rc \
	usr/bin/resolve_device \
	usr/bin/update-grub \
	usr/bin/abswitch \
	usr/bin/blkol \
	usr/bin/tmpdir \
	usr/bin/add-gqueue \
	usr/bin/gearload \
	usr/bin/gstatus-json \
	usr/bin/run-gqueue \
	usr/bin/gstatus \
	usr/bin/gshell \
	usr/bin/mkinitfs \
	usr/bin/ota-update \
	usr/bin/system-update \
	usr/bin/bootless-chroot \
	usr/bin/chroot-setup \
	usr/bin/pipe-setup \
	usr/lib/gearlock/checksum \
	usr/lib/gearlock/decomsize \
	usr/lib/gearlock/extract \
	usr/lib/gearlock/sysup/checkab \
	usr/lib/gearlock/sysup/reinstall_patch \
	usr/lib/gearlock/sysup/mount \
	usr/lib/gearlock/sysup/convert \
	usr/lib/gearlock/sysup/sysup_ab \
	usr/lib/gearlock/sysup/sysup_aonly \
	usr/lib/gearlock/sysup/unmount \
	usr/lib/gearlock/compat/flashablezip/ksu/version.conf \
	usr/lib/gearlock/compat/flashablezip/magisk/version.conf \
	usr/lib/gearlock/compat/flashablezip/install \
	usr/lib/gearlock/compat/flashablezip/convert \
	usr/lib/gearlock/compat/gearlockgxp/convert \
	usr/lib/gearlock/makepkg/genbuild \
	usr/lib/gearlock/.sh \
	usr/lib/gearlock/checkfree \
	usr/share/gearlock/docs/gearlock.md \
	usr/share/gearlock/docs/gxp.md \
	usr/share/gearlock/examples/gxp_format.gear \
	usr/share/gearlock/examples/mkinitfs_hook \
	usr/share/gearlock/examples/mkinitfs_install \
	usr/share/gearlock/mkinitfs/hooks/bliss_features \
	usr/share/gearlock/mkinitfs/hooks/encrypt \
	usr/share/gearlock/mkinitfs/hooks/fsck \
	usr/share/gearlock/mkinitfs/hooks/lvm2 \
	usr/share/gearlock/mkinitfs/hooks/base \
	usr/share/gearlock/mkinitfs/hooks/live_boot \
	usr/share/gearlock/mkinitfs/hooks/live_boot_loop \
	usr/share/gearlock/mkinitfs/hooks/gearlock \
	usr/share/gearlock/mkinitfs/installs/autodetect \
	usr/share/gearlock/mkinitfs/installs/encrypt \
	usr/share/gearlock/mkinitfs/installs/filesystem \
	usr/share/gearlock/mkinitfs/installs/fsck \
	usr/share/gearlock/mkinitfs/installs/gearlock \
	usr/share/gearlock/mkinitfs/installs/keyboard \
	usr/share/gearlock/mkinitfs/installs/live_boot \
	usr/share/gearlock/mkinitfs/installs/live_boot_loop \
	usr/share/gearlock/mkinitfs/installs/lvm2 \
	usr/share/gearlock/mkinitfs/installs/bliss_features \
	usr/share/gearlock/mkinitfs/installs/base \
	usr/share/gearlock/mkinitfs/templates/kernel \
	usr/share/gearlock/mkinitfs/init \
	usr/share/gearlock/extension/execute \
	usr/share/gearlock/first-interation.sh

INSTALL		:= install

build:
	env DEBUG=$(DEBUG) ./build.sh

install:
	for d in $(DIRLIST); do \
		$(INSTALL) -dm755 $(DESTDIR)/$$d;\
	done
	for i in $(FILELIST); do \
		$(INSTALL) -Dm755 build/$$i $(DESTDIR)/$$i;\
	done

clean:
	rm -rf build

.PHONY: clean build
