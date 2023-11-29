# Maintainer: Shadichy <shadichy.dev@gmail.com>

pkgname=gearlock
pkgver=2.0.1
# shellcheck disable=SC2034 # used for git versions, keep around for next time
_ver=${pkgver%_git*}_compat7.3.15
pkgrel=1
pkgdesc="GearLock recovery project for Android on PC"
url="https://github.com/Yuunix-Team/gearlock-core.git"
arch="all"
license="GPL-2.0-only"
# currently we do not ship any testsuite
options="!check"
makedepends_host="bash busybox git"
[ "${DEBUG#0}" ] || makedepends_host="$makedepends_host shfmt"
makedepends="$makedepends_host"
depends="
	busybox-binsh
	busybox>=1.28.2-r1
	bash
	gnupg
	kmod
	mdev-conf
	"
# subpackages="$pkgname-doc"
install="$pkgname.post-install"

provides="initramfs-generator mkinitfs"
provider_priority=900 # highest

build() {
	git submodule update --init
	make VERSION=$pkgver-r$pkgrel DEBUG=$DEBUG
}

package() {
	make install DESTDIR="$pkgdir"
}
