#!/usr/bin/env sh

# Purpose: Support next-generation Yum package manager
# Author : Severus <severus@theslinux.org>
# License: Fair license (http://www.opensource.org/licenses/fair)
# Source : http://github.com/icy/pacapt/

# Copyright (C) 2015 Severus
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works is
# notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.

_dnf_init() {
  if command -v dnf >/dev/null; then
    export DNF_BIN="dnf"
  elif command -v microdnf >/dev/null; then
    export DNF_BIN="microdnf"
  else
    _die "Something wrong with pacapt: dnf/microdnf binary not found."
  fi
}

dnf_S() {
  # shellcheck disable=SC2086
  $DNF_BIN install $_TOPT "$@"
}

dnf_Sc() {
  $DNF_BIN clean expire-cache "$@"
}

dnf_Scc() {
  $DNF_BIN clean packages "$@"
}

dnf_Sccc() {
  $DNF_BIN clean all "$@"
}

dnf_Si() {
  $DNF_BIN repoquery --requires --resolve "$@"
}

dnf_Sii() {
  $DNF_BIN repoquery --installed --whatrequires "$@"
}

dnf_Sg() {
  if [ $# -gt 0 ]; then
    $DNF_BIN group info "$@"
  else
    $DNF_BIN group list
  fi
}

dnf_Sl() {
  $DNF_BIN list available "$@"
}

dnf_Ss() {
  $DNF_BIN search "$@"
}

dnf_Su() {
  $DNF_BIN upgrade "$@"
}

dnf_Suy() {
  $DNF_BIN upgrade "$@"
}

dnf_Sy() {
  $DNF_BIN clean expire-cache && $DNF_BIN check-update
}

# dnf_Q may _not_implemented
dnf_Q() {
  if [ "$_TOPT" = "q" ]; then
    rpm -qa --qf "%{NAME}\\n"
  elif [ -z "$_TOPT" ]; then
    rpm -qa --qf "%{NAME} %{VERSION}\\n"
  else
    _not_implemented
  fi
}

dnf_Qc() {
  rpm -q --changelog "$@"
}

dnf_Qe() {
  $DNF_BIN repoquery --userinstalled "$@"
}

dnf_Qi() {
  case "$DNF_BIN" in
  "dnf")
    $DNF_BIN info --installed "$@" \
    && $DNF_BIN repoquery --deplist "$@"
    ;;
  *)
    _not_implemented
    ;;
  esac
}

dnf_Ql() {
  rpm -ql "$@"
}

dnf_Qm() {
  $DNF_BIN list extras
}

dnf_Qo() {
  if cmd="$(command -v -- "$@")"; then
    rpm -qf "$cmd"
  else
    rpm -qf "$@"
  fi
}

dnf_Qp() {
  rpm -qp "$@"
}

dnf_Qs() {
  rpm -qa "*${*}*"
}

dnf_Qu() {
  case "$DNF_BIN" in
  "dnf")  dnf list updates "$@" ;;
  *)      _not_implemented ;;
  esac
}

dnf_R() {
  $DNF_BIN remove "$@"
}

dnf_U() {
  $DNF_BIN install "$@"
}
