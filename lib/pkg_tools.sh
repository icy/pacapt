#!/bin/bash

# Purpose: OpenBSD support
# Author : Somasis <somasissounds@gmail.com>
# License: Fair license (http://www.opensource.org/licenses/fair)
# Source : http://github.com/somasis/pacapt

# Copyright (C) 2014 Somasis
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works is
# notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.

_pkg_tools_init() {
  :
}

pkg_tools_Qi() {
  # disable searching mirrors for packages
  export PKG_PATH=
  pkg_info "$@"
}

pkg_tools_Ql() {
  export PKG_PATH=
  pkg_info -L "$@"
}

pkg_tools_Qo() {
  export PKG_PATH=
  pkg_info -E "$@"
}

pkg_tools_Qp() {
  _not_implemented
}

pkg_tools_Qu() {
  export PKG_PATH=
  pkg_add -u "$@"
}

pkg_tools_Qq() {
  export PKG_PATH=
  # the dash after the pkg name is so we don't catch partial matches
  # because all packages in openbsd have the format 'pkgname-pkgver'
  if [[ ! -z "$*" ]]; then
    pkg_info -q | grep "^${*}-"
  else
    pkg_info -q
  fi
}

pkg_tools_Q() {
  if [[ ! -z "$*" ]]; then
    # FIXME: Maybe sth wrong with `grep`
    pkg_info | grep "^${*}-"
  else
    pkg_info
  fi
}

pkg_tools_Rs() {
  pkg_delete -D dependencies "$@"
}

pkg_tools_Rn() {
  pkg_delete -c "$@"
}

pkg_tools_R() {
  pkg_delete "$@"
}

pkg_tools_Si() {
  pkg_info "$@"
}

pkg_tools_Sl() {
  pkg_info -L "$@"
}

pkg_tools_Suy() {
  # pkg_tools doesn't really have any concept of a database
  # there's actually not really any database to update, so
  # this function is mostly just for convienience since on arch
  # doing -Su is normally a bad thing to do since it's a partial upgrade

  pkg_tools_Su "$@"
}

pkg_tools_Su() {
  pkg_add -u "$@"
}

pkg_tools_Ss() {
  pkg_info -Q "$@"
}

pkg_tools_Sc() {
  # by default no cache directory is used
  if [[ -z "${PKG_CACHE}" ]];then
    echo "You have no cache directory set, set \$PKG_CACHE for a cache directory."
  elif [[ ! -d "$PKG_CACHE" ]];then
    echo "You have a cache directory set, but it does not exist. Create \"$PKG_CACHE\"."
  else
    _removing_is_dangerous "rm -rf $PKG_CACHE/*"
  fi
}

pkg_tools_S() {
  pkg_add "$@"
}
