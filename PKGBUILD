# Maintainer: Shadichy <shadichy.dev@gmail.com>

pkgname=gearlock
pkgver='2.0.1'
# shellcheck disable=SC2034 # used for git versions, keep around for next time
_ver=${pkgver%_git*}_compat7.3.15
pkgrel=1
pkgdesc="GearLock recovery project for Android on PC"
url="https://github.com/Yuunix-Team/gearlock-core.git"
arch=('any')
license=("GPL-2.0-only")
# currently we do not ship any testsuite
# options="!check"
depends=('busybox' 'bash' 'gnupg' 'kmod' 'pacman' 'udev')
makedepends=('bash' 'busybox' 'git')
[ "${DEBUG#0}" ] || makedepends+=('shfmt')
install="$pkgname.install"
provides=('initramfs-generator' 'mkinitcpio')
# subpackages="$pkgname-doc"

# provides="initramfs-generator mkinitfs"
# provider_priority=900 # highest
# sha512sums=()

prepare() {
	git submodule update --init
	cd ..
	./build.sh arch
}

package() {
	mv -t "$pkgdir" ../build/*
}
