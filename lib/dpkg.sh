#!/usr/bin/env sh

# Purpose: Debian / Ubuntu support
# Author : Anh K. Huynh
# License: Fair license (http://www.opensource.org/licenses/fair)
# Source : http://github.com/icy/pacapt/

# Copyright (C) 2010 - 2021 Anh K. Huynh
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
# FIXME: Need to support a small list of packages
dpkg_Q() {
  if [ "$_TOPT" = "q" ]; then
    dpkg -l \
    | grep -E '^[hi]i' \
    | awk '{print $2}'
  elif [ -z "$_TOPT" ]; then
    dpkg -l "$@" \
    | grep -E '^[hi]i'
  else
    _not_implemented
  fi
}

dpkg_Qc() {
  apt-get changelog "$@"
}

dpkg_Qi() {
  dpkg-query -s "$@"
}

dpkg_Qe() {
  apt-mark showmanual "$@"
}

dpkg_Qk() {
  _require_programs debsums
  debsums "$@"
}

dpkg_Ql() {
  if [ $# -ge 1 ]; then
    dpkg-query -L "$@"
    return
  fi

  dpkg -l \
  | grep -E '^[hi]i' \
  | awk '{print $2}' \
  | while read -r _pkg; do
      if [ "$_TOPT" = "q" ]; then
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
  if cmd="$(command -v -- "$@")"; then
    dpkg-query -S "$cmd"
  else
    dpkg-query -S "$@"
  fi
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
  | grep -Ei "${@:-.}" \
  | _quiet_field1
}

# dpkg_Rs may _not_implemented
dpkg_Rs() {
  if [ -z "$_TOPT" ]; then
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

dpkg_Sg() {
  _require_programs tasksel
  
  if [ $# -gt 0 ]; then
    tasksel --task-packages "$@"
  else
    tasksel --list-task
  fi
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

dpkg_Sy() {
  apt-get update "$@"
}

# FIXME: A simple implementation for #53 and
# FIXME: https://github.com/icy/pacapt/pull/156
# FIXME: but I'm not sure there is any issue...
dpkg_Ss() {
  apt-cache search "${@:-.}" \
  | while read -r name _ desc; do
      if ! dpkg-query -W "$name" > /dev/null 2>&1; then
        printf "package/%s \n    %s\n" \
          "$name" "$desc"
      else
        dpkg-query -W -f='package/${binary:Package} ${Version}\n    ${binary:Summary}\n' "$name"
      fi
  done
}

dpkg_Sc() {
  apt-get clean "$@"
}

dpkg_Scc() {
  apt-get autoclean "$@"
}

dpkg_S() {
  # shellcheck disable=SC2086
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
