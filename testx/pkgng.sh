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
  :
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

pkgng_Q() {
  if [[ "$_TOPT" == "q" ]]; then
    pkg query '%n' "$@"
  elif [[ "$_TOPT" == "" ]]; then
    pkg query '%n %v' "$@"
  else
    _not_implemented
  fi
}

pkgng_Rs() {
  if [[ "$_TOPT" == "" ]]; then
    pkg remove "$@"
    pkg autoremove
  else
    _not_implemented
  fi
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

pkgng_S() {
  if [[ "$_TOPT" == "fetch" ]]; then
    pkg fetch "$@"
  else
    pkg install "$@"
  fi
}
