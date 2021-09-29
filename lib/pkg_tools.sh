#!/usr/bin/env sh

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
  if cmd="$(command -v -- "$@")"; then
    pkg_info -E "$cmd"
  else
    pkg_info -E "$@"
  fi
}

pkg_tools_Qp() {
  _not_implemented
}

pkg_tools_Qu() {
  export PKG_PATH=
  pkg_add -u "$@"
}

# pkg_tools_Q may _not_implemented
pkg_tools_Q() {
  export PKG_PATH=
  # the dash after the pkg name is so we don't catch partial matches
  # because all packages in openbsd have the format 'pkgname-pkgver'
  if [ "$_TOPT" = "q" ] && [ -n "$*" ]; then
    pkg_info -q | grep "^${*}-"
  elif [ "$_TOPT" = "q" ] && [ -z "$*" ];then
    pkg_info -q
  elif [ "$_TOPT" = "" ] && [ -n "$*" ]; then
    pkg_info | grep "^${*}-"
  elif [ "$_TOPT" = "" ] && [ -z "$*" ];then
    pkg_info
  else
    _not_implemented
  fi
}

# pkg_tools_Rs may _not_implemented
pkg_tools_Rs() {
  if [ -z "$_TOPT" ]; then
    pkg_delete -D dependencies "$@"
  else
    _not_implemented
  fi
}

# pkg_tools_rn may _not_implemented
pkg_tools_Rn() {
  if [ -z "$_TOPT" ];then
    pkg_delete -c "$@"
  else
    _not_implemented
  fi
}

# pkg_tools_rns _not_implemented
pkg_tools_Rns() {
  _not_implemented
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
  # this function is mostly just for convenience since on arch
  # doing -Su is normally a bad thing to do since it's a partial upgrade

  pkg_tools_Su "$@"
}

pkg_tools_Su() {
  pkg_add -u "$@"
}

# pkg_tools_Sy _not_implemented
pkg_tools_Sy() {
  _not_implemented
}

# pkg_tools_Ss may _not_implemented
pkg_tools_Ss() {
  if [ -z "$*" ];then
    _not_implemented
  else
    pkg_info -Q "$@"
  fi
}

pkg_tools_Sc() {
  # by default no cache directory is used
  if [ -z "$PKG_CACHE" ];then
    echo "You have no cache directory set, set \$PKG_CACHE for a cache directory."
  elif [ ! -d "$PKG_CACHE" ];then
    echo "You have a cache directory set, but it does not exist. Create \"$PKG_CACHE\"."
  else
    _removing_is_dangerous "rm -rf $PKG_CACHE/*"
  fi
}

# pkg_tools_Scc _not_implemented
pkg_tools_Scc() {
  _not_implemented
}

pkg_tools_S() {
  pkg_add "$@"
}
