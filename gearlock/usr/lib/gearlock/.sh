#!/bin/bash

# Global exported functions, only be used within bash (shebang #!/bin/bash)
# Other shells like busybox sh, toybox sh or else may need implement of themselves

die() { echo "==> ERROR: $1" >&2 && quit "${2:-1}"; }

# Override this if needed
quit() { exit "$1"; }

checkfree() { "$GEARLIB"/checkfree "$@"; }

decomsize() { "$GEARLIB"/decomsize "$@"; }

extract() { "$GEARLIB"/extract "$@"; }

sysup.checkab() { "$GEARLIB"/sysup/checkab "$@"; }

sysup.reinstall_patch() { "$GEARLIB"/sysup/reinstall_patch "$@"; }

sysup.sysup_ab() { "$GEARLIB"/sysup/sysup_ab "$@"; }

sysup.sysup_aonly() { "$GEARLIB"/sysup/sysup_aonly "$@"; }

sysup.convert() { "$GEARLIB"/sysup/convert "$@"; }

compat.flashablezip.install() { "$GEARLIB"/compat/flashablezip/install "$@"; }

compat.flashablezip.convert() { "$GEARLIB"/compat/flashablezip/convert "$@"; }

compat.gearlockgxp.convert() { "$GEARLIB"/compat/gearlockgxp/convert "$@"; }

makepkg.genbuild() { "$GEARLIB"/makepkg/genbuild "$@"; }

export -f checkfree decomsize extract sysup.checkab sysup.reinstall_patch sysup.sysup_ab sysup.sysup_aonly sysup.convert compat.flashablezip.install compat.flashablezip.convert compat.gearlockgxp.convert makepkg.genbuild
