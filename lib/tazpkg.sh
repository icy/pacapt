#!/bin/bash

# Purpose: Provide Slitaz support for pacapt script
# Author : Anh K. Huynh
# Date   : 2016 July 08th
# License: MIT

_tazpkg_init() {
  :
}

tazpkg_Qq() {
  tazpkg list "$@" \
  | awk '{ if (NF == 2 || NF == 3) { print $1; }}'
}

tazpkg_Q() {
  tazpkg list "$@"
}

tazpkg_Qi() {
  tazpkg info "$@"
}

tazpkg_Qql() {
  : "${QUIET_MODE:=1}"
  tazpkg_Ql "$@"
}

tazpkg_Ql() {
  : "${QUIET_MODE:=0}"
  if [ "${QUIET_MODE}" = "1" ]; then
    {
      tazpkg list-files "$@"
      tazpkg list-config "$@"
    } \
    | grep ^/
  else
    tazpkg list-files "$@"
    tazpkg list-config "$@"
  fi
}

tazpkg_Sy() {
  tazpkg recharge
}

tazpkg_Su() {
  tazpkg up
}

tazpkg_Suy() {
  tazpkg_Sy \
  && tazpkg_Su
}

tazpkg_S() {
  local _forced=""

  if grep -q -- "--forced" <<<"$*"; then
    _forced="--forced"
  fi

  while (( $# )); do
    if [[ "$1" == "--forced" ]]; then
      _forced="--forced"
      shift
      continue
    fi

    tazpkg get-install "$1" $_forced
    shift
  done
}

tazpkg_R() {
  local _auto=""

  if grep -q -- "--auto" <<<"$*"; then
    _auto="--auto"
  fi

  while (( $# )); do
    if [[ "$1" == "--auto" ]]; then
      _auto="--auto"
      shift
      continue
    fi

    tazpkg remove "$1" $_auto
    shift
  done
}

tazpkg_Sc() {
  tazpkg clean-cache
}

tazpkg_Scc() {
  tazpkg clean-cache
  cd /var/lib/tazpkg/ \
  && {
    rm -fv \
      ./*.bak \
      ID \
      packages.* \
      files.list.*
  }
}

# Option: tazpkg search ... [option]
# -i: installed packages
# -l: available packages
tazpkg_Ss() {
  tazpkg search "$@"
}

tazpkg_Qo() {
  tazpkg search-pkgname "$@"
}

tazpkg_U() {
  local _forced=""

  if grep -q -- "--forced" <<<"$*"; then
    _forced="--forced"
  fi

  while (( $# )); do
    if [[ "$1" == "--forced" ]]; then
      _forced="--forced"
      shift
      continue
    fi

    tazpkg install "$1" $_forced
    shift
  done
}
