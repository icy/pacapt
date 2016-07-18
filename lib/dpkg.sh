#!/bin/bash

# Purpose: Debian / Ubuntu support
# Author : Anh K. Huynh
# License: Fair license (http://www.opensource.org/licenses/fair)
# Source : http://github.com/icy/pacapt/

# Copyright (C) 2010 - 2014 Anh K. Huynh
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works is
# notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.

# test.in -Sy
# test.ou .+
_dpkg_init() {
  :
}

# test.in -Qq
# test.ou ^apt$
# test.in -Q
# test.ou ^ii +apt +.+ubuntu
dpkg_Q() {
  if [[ "$_TOPT" == "q" ]]; then
    dpkg -l \
    | grep -E '^[hi]i' \
    | awk '{print $2}'
  elif [[ "$_TOPT" == "" ]]; then
    dpkg -l "$@" \
    | grep -E '^[hi]i'
  else
    _not_implemented
  fi
}

# test.in -Qi apt
# test.ou ^Package: apt$
# test.ou ^Status: install ok installed$
# test.ou ^Priority: important$
dpkg_Qi() {
  dpkg-query -s "$@"
}

# test.in -Ql apt
# test.ou ^/usr/bin/apt
# test.in -Ql
# test.ou ^apt /usr/bin/apt$
# test.in -Qql
# test.ou ^/usr/bin/apt$
dpkg_Ql() {
  if [[ -n "$@" ]]; then
    dpkg-query -L "$@"
    return
  fi

  dpkg -l \
  | grep -E '^[hi]i' \
  | awk '{print $2}' \
  | while read _pkg; do
      if [[ "$_TOPT" == "q" ]]; then
        dpkg-query -L "$_pkg"
      else
        dpkg-query -L "$_pkg" \
        | while read _line; do
            echo "$_pkg $_line"
          done
      fi
    done
}

# test.in -Qo /bin/bash
# test.ou ^bash: /bin/bash$
dpkg_Qo() {
  dpkg-query -S "$@"
}

dpkg_Qp() {
  dpkg-deb -I "$@"
}

dpkg_Qu() {
  apt-get upgrade --trivial-only "$@"
}

dpkg_Qs() {
  dpkg-query -W -f='${db:Status-Abbrev} ${binary:Package}\t${Version}\t${binary:Summary}\n' \
  | grep -E '^[hi]i' \
  | sed -r -e 's#^[hi]i +##' \
  | grep "${@:-.}"
}

dpkg_Rs() {
  if [[ "$_TOPT" == "" ]]; then
    apt-get autoremove "$@"
  else
    _not_implemented
  fi
}

dpkg_Rn() {
  apt-get purge "$@"
}

dpkg_Rns() {
  apt-get --purge autoremove "$@"
}

# test.in -S htop
# test.in -R htop
# test.in -Qi htop
# test.ou ^Status: deinstall
dpkg_R() {
  apt-get remove "$@"
}

dpkg_Si() {
  apt-cache show "$@"
}

dpkg_Suy() {
  apt-get update \
  && apt-get upgrade "$@"
}

dpkg_Su() {
  apt-get upgrade "$@"
}

# See also https://github.com/icy/pacapt/pull/78
# This `-w` option is implemented in `00_core/_translate_w`
#
# dpkg_Sw() {
#   apt-get --download-only install "$@"
# }

# FIXME: Should we remove "$@"?
dpkg_Sy() {
  apt-get update "$@"
}

dpkg_Ss() {
  apt-cache search "$@"
}

dpkg_Sc() {
  apt-get clean "$@"
}

dpkg_Scc() {
  apt-get autoclean "$@"
}

# test.in -Sccc
# test.in clear
# test.in -sS mariadb
# test.ou empty
dpkg_Sccc() {
  rm -fv /var/cache/apt/*.bin
  rm -fv /var/cache/apt/archives/*.*
  rm -fv /var/lib/apt/lists/*.*
  apt-get autoclean
}

dpkg_S() {
  apt-get install $_TOPT "$@"
}

dpkg_U() {
  dpkg -i "$@"
}

dpkg_Sii() {
  apt-cache rdepends "$@"
}
