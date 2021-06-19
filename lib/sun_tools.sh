#!/usr/bin/env sh

# POSIX  : Ready
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

# Initialize special things for SunOS system.
# This method is invoked on any system though,
# and it returns 1 if the current OS is not SunOS.
_sun_tools_init() {
  # The purpose of `if` is to make sure this function
  # can be invoked on other system (Linux, BSD).
  if [ "$(uname)" = "SunOS" ]; then
    export GREP=/usr/xpg4/bin/grep
    export AWK=nawk
    return 0
  fi
  return 1
}

sun_tools_Qi() {
  pkginfo -l "$@"
}

sun_tools_Ql() {
  pkginfo -l "$@"
}

sun_tools_Qo() {
  if cmd="$(command -v -- "$@")"; then
    $GREP "$cmd" /var/sadm/install/contents
  else
    $GREP "$@" /var/sadm/install/contents
  fi
}

sun_tools_Qs() {
  pkginfo | $GREP -i "$@"
}

sun_tools_Q() {
  # the dash after the pkg name is so we don't catch partial matches
  # because all packages in openbsd have the format 'pkgname-pkgver'
  if [ "$_TOPT" = "q" ] && [ -n "$*" ]; then
    pkginfo | $GREP "$@"
  elif [ "$_TOPT" = "q" ] && [ -z "$*" ]; then
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
