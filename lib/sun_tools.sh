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

_sun_tools_init() {
  GREP=/usr/xpg4/bin/grep
  AWK=nawk
}

sun_tools_Qi() {
  pkginfo -l "$@"
}

sun_tools_Ql() {
  pkginfo -l "$@"
}

sun_tools_Qo() {
  grep "$@" /var/sadm/install/contents
}

sun_tools_Qs() {
  pkginfo | grep -i "$@"
}

sun_tools_Q() {
  # the dash after the pkg name is so we don't catch partial matches
  # because all packages in openbsd have the format 'pkgname-pkgver'
  if [[ "$_TOPT" == "q" && ! -z "$@" ]]; then
    pkginfo | grep "$@"
  elif [[ "$_TOPT" == "q" && -z "$@" ]];then
    pkginfo
  else
    pkginfo "$@"
  fi
}

sun_tools_R() {
  pkgrm "$@"
}

sun_tools_U() {
  pkgadd "$@"
}
