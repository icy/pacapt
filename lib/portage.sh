#!/usr/bin/env sh

# Purpose: Gentoo support
# Author : Hà-Dương Nguyễn
# License: Fair license (http://www.opensource.org/licenses/fair)
# Source : http://github.com/icy/pacapt/

# Copyright (C) 2010 - 2014 Hà-Dương Nguyễn
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works is
# notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.

_portage_init() {
  :
}

portage_Qi() {
  emerge --info "$@"
}

portage_Ql() {
  if [ -x '/usr/bin/qlist' ]; then
    qlist "$@"
  elif [ -x '/usr/bin/equery' ]; then
    equery files "$@"
  else
    _error "'portage-utils' or 'gentoolkit' package is required to perform this operation."
  fi
}

portage_Qo() {
  if [ -x '/usr/bin/equery' ]; then
    if cmd="$(command -v -- "$@")"; then
      equery belongs "$cmd"
    else
      equery belongs "$@"
    fi
  else
    _error "'gentoolkit' package is required to perform this operation."
  fi
}

portage_Qc() {
  emerge -p --changelog "$@"
}

# FIXME: may not be correct
portage_Qu() {
  emerge -uvN "$@"
}

portage_Q() {
  if [ -z "$_TOPT" ]; then
    if [ -x '/usr/bin/eix' ]; then
      eix -I "$@"
    elif [ -x '/usr/bin/equery' ]; then
      equery list -i "$@"
    else
      LS_COLORS="never" \
      ls -1 -d /var/db/pkg/*/*
    fi
  else
    _not_implemented
  fi
}

portage_Rs() {
  if [ -z "$_TOPT" ]; then
    emerge --depclean world "$@"
  else
    _not_implemented
  fi
}

portage_R() {
  emerge --depclean "$@"
}

portage_Si() {
  emerge --info "$@"
}

portage_Suy() {
  if [ -x '/usr/bin/layman' ]; then
    layman --sync-all \
    && emerge --sync \
    && emerge -auND world "$@"
  else
    emerge --sync \
    && emerge -uND world "$@"
  fi
}

portage_Su() {
  emerge -uND world "$@"
}

portage_Sy() {
  if [ -x "/usr/bin/layman" ]; then
    layman --sync-all \
    && emerge --sync "$@"
  else
    emerge --sync "$@"
  fi
}

portage_Ss() {
  if [ -x "/usr/bin/eix" ]; then
    eix "$@"
  else
    emerge --search "$@"
  fi
}

portage_Sc() {
  if [ -x "/usr/bin/eclean-dist" ]; then
    eclean-dist -d -t1m -s50 -f "$@"
  else
    _error "'gentoolkit' package is required to perform this operation."
  fi
}

portage_Scc() {
  if [ -x "/usr/bin/eclean" ]; then
    eclean -i distfiles "$@"
  else
    _error "'gentoolkit' package is required to perform this operation."
  fi
}

portage_Sccc() {
  rm -fv /usr/portage/distfiles/*.*
}

portage_S() {
  emerge "$@"
}
