#!/bin/bash

mkdir -p build
DISTRO=$1

declare -A DIST_EXCLUDE=(["alpine"]="etc/apk" ["arch"]="usr/share/libalpm" ["void"]="" ["debian"]="")

EXCLUDES=""
for dist in "${!DIST_EXCLUDE[@]}"; do
	{ [ ! "${DIST_EXCLUDE["$dist"]}" ] || [ "${DIST_EXCLUDE["$dist"]}" = "$DISTRO" ]; } && continue
	EXCLUDES="$EXCLUDES|${DIST_EXCLUDE["$dist"]}"
done
EXCLUDES=${EXCLUDES#|}

FILELIST=$(find gearlock -mindepth 1 -type f | grep -Ev "$EXCLUDES")
LINKLIST=$(find gearlock -mindepth 1 -type l | grep -Ev "$EXCLUDES")

while read -r file; do
	header=$(head -1 "$file")
	target=build/${file#gearlock}

	target_dir=${target%/*}
	[ -d "$target_dir" ] || mkdir -p "$target_dir"

	case "$header" in
	\#\!/*)
		[ "${DEBUG#0}" ] &&
			cp -a "$file" "$target" ||
			shfmt -mn "$file" >"$target" ||
			shfmt -mn -ln=mksh "$file" >"$target"
		chmod +x "$target"
		;;
	*) cp "$file" "$target" ;;
	esac

done <<<"$FILELIST"

while read -r file; do
	target=build/${file#gearlock}

	target_dir=${target%/*}
	[ -d "$target_dir" ] || mkdir -p "$target_dir"

	cp -a "$(readlink -f "$file")" "$target"
done <<<"$LINKLIST"

postins='
export PATH=/bin:/sbin:/usr/local/bin:/usr/bin:/usr/sbin

cd /
mkdir -p \
	android \
	boot \
	var/gearlock/overlay \
	data \
	data_mirror \
	system \
	storage \
	sdcard \
	apex \
	linkerconfig \
	debug_ramdisk \
	system_ext \
	product \
	vendor

echo "localhost" >/etc/hostname

gpg --batch --passphrase "" --quick-gen-key "root@localhost" default default
'
case "$DISTRO" in
alpine)
	cat <<EOF >gearlock.post-install
#!/bin/bash
$postins
abuild-keygen --append
EOF
	;;
arch)
	cat <<EOF >gearlock.install
#!/bin/bash
post_install() {
$postins
}
EOF
	;;
void)
	cat <<EOF >INSTALL
#!/bin/bash
case "\$ACTION" in
post)
$postins
;;
esac
EOF
	;;
debian) ;;
esac
