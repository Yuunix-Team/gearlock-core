# Maintainer: Shadichy <shadichy.dev@gmail.com>
pkgname=gearlock
pkgver=2:7.3.15
# shellcheck disable=SC2034 # used for git versions, keep around for next time
_ver=${pkgver%_git*}
pkgrel=1
pkgdesc="GearLock recovery project for Android on PC"
url="https://github.com/Yuunix-Team/gearlock-core"
arch="all"
license="GPL-2.0-only"
# currently we do not ship any testsuite
options="!check"
makedepends_host="bash busybox git"
makedepends="$makedepends_host"
depends="
	busybox-binsh
	busybox>=1.28.2-r1
	bash
	gnupg
	kmod
	lddtree>=1.25
	mdev-conf
	"
subpackages="$pkgname-doc"
# install="$pkgname.pre-upgrade $pkgname.post-install $pkgname.post-upgrade"

provides="gearlock initramfs-generator mkinitfs"
provider_priority=900 # highest

build() {
	git submodule init
	git submodule update
	make VERSION=$pkgver-r$pkgrel
}

package() {
	make install DESTDIR="$pkgdir"
}
