#!/usr/bin/env sh

# Purpose: Support opkg (e.g. OpenWrt)
# Author : Ky-Anh Huynh
# License: Fair license (http://www.opensource.org/licenses/fair)
# Source : http://github.com/icy/pacapt/

# Copyright (C) 2021 Ky-Anh Huynh
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works is
# notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.

_opkg_init() {
  :
}

opkg_Sy() {
  opkg update
}

opkg_Q() {
  # shellcheck disable=SC2016
  case "$_TOPT" in
  "q")
    opkg list-installed "$@" | "$AWK" '{print $1}'
    ;;
  "")
    opkg list-installed "$@"
    ;;
  *)
    _not_implemented
    ;;
  esac
}

opkg_Qi() {
  for  pkg in $(opkg__get_local_pkgs "${@}"); do
    opkg info "$pkg"
  done
}

# Get list of installed-packages from user list.
opkg__get_local_pkgs() {
  if [ "$#" -eq 0 ]; then
    # shellcheck disable=SC2016
    opkg list-installed | "$AWK" '{print $1}'
  else
    # `opkg status` returns empty if package is not installed/removed.
    # shellcheck disable=SC2016
    for pkg in "${@}"; do
      opkg status "$pkg"
    done \
    | "$AWK" '/^Package: / {print $NF}'
  fi
}

opkg_Ql() {
  for pkg in $(opkg__get_local_pkgs "${@}"); do
    # shellcheck disable=SC2016
    opkg files "$pkg" \
    | PKG="$pkg" "$AWK" \
        '{ if (NR>1) {printf("%s %s\n", ENVIRON["PKG"], $0)} }'
  done
}

opkg_Qo() {
  if cmd="$(command -v -- "$@")"; then
    opkg search "$cmd"
  else
    opkg search "$@"
  fi
}

opkg_Qs() {
  if command -v sort >/dev/null; then
    local_filter="sort -u"
  else
    local_filter="cat"
  fi

  # FIXME: opkg doesn't work with wildcard by default.
  case "$@" in
  *\**) local_pattern="$*" ;;
  *)    local_pattern="*${*}*" ;;
  esac

  opkg search "$local_pattern" \
  | ${local_filter} \
  | _quiet_field1
}

# FIXME: It's not easy to test this method =))
opkg_Qu() {
  opkg list-upgradable
}

opkg_R() {
  opkg remove "$@"
}

opkg_S() {
  opkg install "$@"
}

opkg_Si() {
  opkg list $_TOPT "$@"
}

opkg_Sii() {
  opkg list $_TOPT "$@"
  opkg whatdepends "$@"
}

opkg_Ss() {
  opkg list "$@"
}

opkg_Su() {
  opkg upgrade "$@"
}

opkg_U() {
  opkg install "$@"
}
