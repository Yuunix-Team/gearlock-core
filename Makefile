
DESTDIR := /
DEBUG := 0

DIRLIST := usr \
	usr/share \
	usr/share/gearlock \
	usr/share/gearlock/mkinitfs \
	usr/share/gearlock/mkinitfs/hooks \
	usr/share/gearlock/mkinitfs/installs \
	usr/share/gearlock/mkinitfs/templates \
	usr/share/gearlock-legacy \
	usr/bin \
	usr/lib \
	usr/lib/gearlock \
	usr/lib/gearlock/gxp \
	usr/lib/gearlock/sysup \
	etc \
	etc/grub.d \
	etc/gxp.d

FILELIST := usr/share/gearlock/mkinitfs/hooks/fsck \
	usr/share/gearlock/mkinitfs/hooks/live_boot \
	usr/share/gearlock/mkinitfs/hooks/live_boot_loop \
	usr/share/gearlock/mkinitfs/hooks/gearlock \
	usr/share/gearlock/mkinitfs/hooks/lvm2 \
	usr/share/gearlock/mkinitfs/hooks/bliss_features \
	usr/share/gearlock/mkinitfs/hooks/encrypt \
	usr/share/gearlock/mkinitfs/hooks/base \
	usr/share/gearlock/mkinitfs/installs/fsck \
	usr/share/gearlock/mkinitfs/installs/live_boot \
	usr/share/gearlock/mkinitfs/installs/filesystem \
	usr/share/gearlock/mkinitfs/installs/autodetect \
	usr/share/gearlock/mkinitfs/installs/live_boot_loop \
	usr/share/gearlock/mkinitfs/installs/gearlock \
	usr/share/gearlock/mkinitfs/installs/base \
	usr/share/gearlock/mkinitfs/installs/keyboard \
	usr/share/gearlock/mkinitfs/installs/lvm2 \
	usr/share/gearlock/mkinitfs/installs/bliss_features \
	usr/share/gearlock/mkinitfs/installs/encrypt \
	usr/share/gearlock/mkinitfs/templates/kernel \
	usr/share/gearlock/mkinitfs/init \
	usr/share/gearlock-legacy/.compat \
	usr/bin/gstatus-json \
	usr/bin/update-grub \
	usr/bin/gxp \
	usr/bin/abswitch \
	usr/bin/system-update \
	usr/bin/gearload \
	usr/bin/booted-chroot \
	usr/bin/bootless-chroot \
	usr/bin/populate-keys \
	usr/bin/gshell \
	usr/bin/resolve_device \
	usr/bin/mkinitfs \
	usr/bin/gqueue \
	usr/lib/gearlock/gxp/install \
	usr/lib/gearlock/gxp/remove \
	usr/lib/gearlock/gxp/upgrade \
	usr/lib/gearlock/gxp/fetch \
	usr/lib/gearlock/gxp/installfile \
	usr/lib/gearlock/gxp/parse \
	usr/lib/gearlock/checkfree \
	usr/lib/gearlock/decomsize \
	usr/lib/gearlock/checksum \
	usr/lib/gearlock/sysup/sysup_ab \
	usr/lib/gearlock/sysup/sysup_aonly \
	usr/lib/gearlock/sysup/checkab \
	usr/lib/gearlock/sysup/reinstall_patch \
	usr/lib/gearlock/sysup/convert \
	usr/lib/gearlock/extract \
	etc/gxp.conf \
	etc/grub.d/10_android \
	etc/gearlock.conf \
	etc/mkinitfs.conf \
	etc/gxp.d/default

DOCSDIR := usr/share/gearlock/examples \
	usr/share/gearlock/docs 

DOCSFILE := usr/share/gearlock/examples/gxp_format.gear \
	usr/share/gearlock/examples/mkinitfs_hook \
	usr/share/gearlock/examples/mkinitfs_install \
	usr/share/gearlock/docs/gearlock.md \
	usr/share/gearlock/docs/gxp.md

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
	for d in $(DOCSDIR); do \
		$(INSTALL) -dm644 $(DESTDIR)/$$d;\
	done
	for i in $(DOCSFILE); do \
		$(INSTALL) -D build/$$i $(DESTDIR)/$$i;\
	done

clean:
	rm -rf build
