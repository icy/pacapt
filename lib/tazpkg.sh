#!/bin/bash

# Purpose: Provide Slitaz support for pacapt script
# Author : Anh K. Huynh
# Date   : 2016 July 08th
# License: MIT

_tazpkg_init() {
  :
}

tazpkg_Q() {
  if [[ "$_TOPT" == "q" ]]; then
    tazpkg list "$@" \
    | awk '{ if (NF == 2 || NF == 3) { print $1; }}'
  elif [[ "$_TOPT" == "" ]]; then
    tazpkg list "$@"
  else
    _not_implemented
  fi
}

tazpkg_Qi() {
  tazpkg info "$@"
}

tazpkg_Ql() {
  if [[ -z "$@" ]]; then
    _not_implemented
    return
  fi

  if [[ "$_TOPT" == "q" ]]; then
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
  tazpkg remove "$@"
}

tazpkg_Sc() {
  tazpkg clean-cache
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
