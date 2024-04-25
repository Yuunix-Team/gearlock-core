#!/bin/busybox sh

export PATH=/usr/local/bin:/usr/bin:/usr/sbin:/bin:/sbin

for i in "$@"; do
	case "$i" in
	/lib/modules/* | /usr/lib/modules/*)
		if [ -d "$i" ]; then
			mkinitfs -K "$(basename "$i")"
			continue
		fi

		remove_kernel() {
			filelist="/boot/vmlinuz-${1} /boot/initrd-${1}.img /efi/EFI/Android/vmlinuz-${1}.efi"

			# access all the files to trigger any potential automounts
			stat -- /boot/ /efi/ $filelist >/dev/null 2>&1

			# remove the actual kernel and images for the package being removed
			rm -f -- "$filelist"
		}

		remove_kernel "$i"
		;;
	/lib/firmware/* | /usr/lib/firmware/*) mkinitfs -a ;;
	/usr/share/gearlock/extensions/*)
		case "$i" in
		*.zip) xtype=flashablezip ;;
		*.gxp) xtype=gearlockgxp ;;
		*) continue ;;
		esac
		/usr/lib/gearlock/compat/"$xtype"/install "$i"
		;;
	/etc/init/gearlock) find /etc/init/gearlock -type f -exec printf "\nimport /data/adb/gearlock%s\n" {} + >/etc/init/sources.rc ;;
	esac
done
