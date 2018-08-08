#!/bin/bash

# Purpose: FreeBSD support
# Author : Konrad Borowski
# Date   : Dec 18 2013
# License: Fair license (http://www.opensource.org/licenses/fair)
# Source : http://github.com/icy/pacapt/
# Pull   : https://github.com/icy/pacapt/pull/25
# Note   : The pull request is applicable to `master` branch.
#          Anh K. Huynh slightly modified the pull request to
#          use them on the `ng` branch (on May 05 2014)

# Copyright (C) 2013 - 2014 Konrad Borowski
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works is
# notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.

_pkgng_init() {
  export PASSTHROUGH=pkg
}

pkgng_Qi() {
  pkg info "$@"
}

pkgng_Ql() {
  pkg info -l "$@"
}

pkgng_Qo() {
  pkg which "$@"
}

pkgng_Qp() {
  pkg query -F "$@" '%n %v'
}

pkgng_Qu() {
  pkg upgrade -n "$@"
}

pkgng_Qq() {
  pkg query '%n' "$@"
}

pkgng_Q() {
  pkg query '%n %v' "$@"
}

pkgng_Rs() {
  pkg remove "$@"
  pkg autoremove
}

pkgng_R() {
  pkg remove "$@"
}

pkgng_Si() {
  pkg search -S name -ef "$@"
}

pkgng_Suy() {
  pkg upgrade "$@"
}

pkgng_Su() {
  pkg upgrade -U "$@"
}

pkgng_Sy() {
  pkg update "$@"
}

pkgng_Ss() {
  pkg search "$@"
}

pkgng_Sc() {
  pkg clean "$@"
}

pkgng_Scc() {
  pkg clean -a "$@"
}

pkgng_Sw() {
  # NOTE: $1 is always a fetch
  pkg "$@"
}

pkgng_Q() {
  pkg install "$@"
}
