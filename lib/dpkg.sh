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

_dpkg_init() {
  :
}

# dpkg_Q may _not_implemented
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

dpkg_Qi() {
  dpkg-query -s "$@"
}

dpkg_Ql() {
  if [[ -n "$*" ]]; then
    dpkg-query -L "$@"
    return
  fi

  dpkg -l \
  | grep -E '^[hi]i' \
  | awk '{print $2}' \
  | while read -r _pkg; do
      if [[ "$_TOPT" == "q" ]]; then
        dpkg-query -L "$_pkg"
      else
        dpkg-query -L "$_pkg" \
        | while read -r _line; do
            echo "$_pkg $_line"
          done
      fi
    done
}

dpkg_Qo() {
  dpkg-query -S "$@"
}

dpkg_Qp() {
  dpkg-deb -I "$@"
}

dpkg_Qu() {
  apt-get upgrade --trivial-only "$@"
}

# NOTE: Some field is available for dpkg >= 1.16.2
# NOTE: Debian:Squeeze has dpkg < 1.16.2
dpkg_Qs() {
  # dpkg >= 1.16.2 dpkg-query -W -f='${db:Status-Abbrev} ${binary:Package}\t${Version}\t${binary:Summary}\n'
  dpkg-query -W -f='${Status} ${Package}\t${Version}\t${Description}\n' \
  | grep -E '^((hold)|(install)|(deinstall))' \
  | sed -r -e 's#^(\w+ ){3}##g' \
  | grep -Ei "${@:-.}"
}

# dpkg_Rs may _not_implemented
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

dpkg_R() {
  apt-get remove "$@"
}

dpkg_Si() {
  apt-cache show "$@"
}

dpkg_Suy() {
  apt-get update \
  && apt-get upgrade "$@" \
  && apt-get dist-upgrade "$@"
}

dpkg_Su() {
  apt-get upgrade "$@" \
  && apt-get dist-upgrade "$@"
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

dpkg_S() {
  apt-get install $_TOPT "$@"
}

dpkg_U() {
  dpkg -i "$@"
}

dpkg_Sii() {
  apt-cache rdepends "$@"
}

dpkg_Sccc() {
  rm -fv /var/cache/apt/*.bin
  rm -fv /var/cache/apt/archives/*.*
  rm -fv /var/lib/apt/lists/*.*
  apt-get autoclean
}
