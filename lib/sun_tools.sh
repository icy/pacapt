# Purpose: SunOS support
# Author : Daniel YC Lin <dlin.tw@gmail.com>
# License: Fair license (http://www.opensource.org/licenses/fair)
# Source : http://github.com/dlintw/pacapt

# Copyright (C) 2015 Daniel YC Lin
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
  pkginfo -l "$@"
}

pkg_tools_Ql() {
  pkginfo -l "$@"
}

pkg_tools_Qo() {
  grep "$@" /var/sadm/install/contents
}

pkg_tools_Qp() {
  _not_implemented
}

pkg_tools_Qu() {
  _not_implemented
}

pkg_tools_Q() {
  # the dash after the pkg name is so we don't catch partial matches
  # because all packages in openbsd have the format 'pkgname-pkgver'
  if [[ "$_TOPT" == "q" && ! -z "$@" ]]; then
    pkginfo | grep "$@"
  elif [[ "$_TOPT" == "q" && -z "$@" ]];then
    pkg_info
  else
    pkg_info "$@"
  fi
}

pkg_tools_Rs() {
  _not_implemented
}

pkg_tools_Rn() {
  _not_implemented
}

pkg_tools_Rns() {
  _not_implemented
}

pkg_tools_R() {
  pkgrm "$@"
}

pkg_tools_Si() {
  _not_implemented
}

pkg_tools_Sl() {
  _not_implemented
}

pkg_tools_Suy() {
  _not_implemented
}

pkg_tools_Su() {
  _not_implemented
}

pkg_tools_Sy() {
  _not_implemented
}

pkg_tools_Ss() {
  _not_implemented
}

pkg_tools_Sc() {
  _not_implemented
}

pkg_tools_Scc() {
  _not_implemented
}

pkg_tools_S() {
  _not_implemented
}
pkg_tools_U() {
  pkgadd "$@"
}
