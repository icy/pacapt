#!/bin/bash

# Purpose: Gentoo (+ Paludis) / Exherbo support
# Author : Somasis <somasissounds@gmail.com>
# License: Fair license (http://www.opensource.org/licenses/fair)
# Source : http://github.com/somasis/pacapt/
# Cave   : http://paludis.exherbo.org/clients/cave.html

# Copyright (C) 2014 Somasis
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works is
# notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.

# cave uses asterisks pretty liberally, this is for output parsing correctness
_cave_init() {
  shopt -u globstar
}

cave_Qq() {
  cave show -f "${@:-world}" \
  | grep -v '^$'
}

cave_Q() {
  cave show -f "${@:-world}"
}

cave_Qi() {
  cave show "$@"
}

cave_Qlq() {
  : "${QUIET_MODE:=1}"
  cave_Ql "$@"
}

cave_Ql() {
  : "${QUIET_MODE:=0}"

  if [[ -n "$*" ]]; then
    cave contents "$@"
    return
  fi

  cave show -f "${@:-world}" \
  | grep -v '^$' \
  | while read -r _pkg; do
      if [ "${QUIET_MODE}" = "1" ]; then
        cave --color no contents "$_pkg"
      else
        cave contents "$_pkg"
      fi
    done
}

cave_Qo() {
  cave owner "$@"
}

cave_Qu() {
  if [[ -z "$*" ]];then
    cave resolve -c world \
    | grep '^u.*' \
    | while read -r _pkg; do
        echo "$_pkg" | cut -d'u' -f2-
      done
  else
    cave resolve -c world \
    | grep '^u.*' \
    | grep -- "$@"
  fi
}

cave_Qs() {
  cave show -f world | grep -- "$@"
}

## FIXME: Wrong use...
cave_Rs() {
  cave uninstall -r "$@" \
  && echo "Control-C to stop uninstalling..." \
  && sleep 2s \
  && cave uninstall -xr "$@"
}

## FIXME: Wrong use...
cave_Ru() {
  ## Uninstall unused packages.
  cave purge "$@" \
  && echo "Control-C to stop uninstalling (+ dependencies)..." \
  && sleep 2s \
  && cave purge -x "$@"
}

cave_R() {
  cave uninstall "$@" \
  && echo "Control-C to stop uninstalling..." \
  && sleep 2s \
  && cave uninstall -x "$@"
}

cave_Si() {
  cave show "$@"
}

cave_Suy() {
  cave sync && cave resolve -c "${@:-world}" \
  && echo "Control-C to stop upgrading..." \
  && sleep 2s \
  && cave resolve -cx "${@:-world}"
}

cave_Su() {
  cave resolve -c "$@" \
  && echo "Control-C to stop upgrading..." \
  && sleep 2s \
  && cave resolve -cx "$@"
}

cave_Sy() {
  cave sync "$@"
}

cave_Ss() {
  cave search "$@"
}

cave_Sc() {
  cave fix-cache "$@"
}

cave_Scc() {
  cave fix-cache "$@"
}

cave_S() {
  cave resolve "$@" \
  && echo "Control-C to stop installing..." \
  && sleep 2s \
  && cave resolve -x "$@"
}
