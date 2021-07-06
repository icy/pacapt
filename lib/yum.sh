#!/usr/bin/env sh

# Purpose: RedHat / Fedora Core support
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

_yum_init() {
  :
}

# FIXME: Need to support a small list of packages
yum_Q() {
  if [ "$_TOPT" = "q" ]; then
    rpm -qa --qf "%{NAME}\\n"
  elif [ -z "$_TOPT" ]; then
    rpm -qa --qf "%{NAME} %{VERSION}\\n"
  else
    _not_implemented
  fi
}

yum_Qi() {
  yum info "$@"
}

yum_Qs() {
  if [ "$_TOPT" = "q" ]; then
    rpm -qa --qf "%{NAME}\\n" "*${*}*"
  elif [ -z "$_TOPT" ]; then
    rpm -qa --qf "%{NAME} %{VERSION}\\n" "*${*}*"
  else
    _not_implemented
  fi
}

yum_Ql() {
  rpm -ql "$@"
}

yum_Qo() {
  if cmd="$(command -v -- "$@")"; then
    rpm -qf "$cmd"
  else
    rpm -qf "$@"
  fi
}

yum_Qp() {
  rpm -qp "$@"
}

yum_Qc() {
  rpm -q --changelog "$@"
}

yum_Qu() {
  yum list updates "$@"
}

yum_Qm() {
  yum list extras "$@"
}

yum_Rs() {
  if [ -z "$_TOPT" ]; then
    yum erase "$@"
  else
    _not_implemented
  fi
}

yum_R() {
  yum erase "$@"
}

yum_Si() {
  if ! command -v repoquery > /dev/null 2>&1; then
    _die "pacapt: repoquery binary does not exist in system."
  fi

  repoquery --requires --resolve "$@"
}

yum_Suy() {
  yum update "$@"
}

yum_Su() {
  yum update "$@"
}

yum_Sy() {
  yum check-update "$@"
}

yum_Ss() {
  yum -C search "$@"
}

yum_Sc() {
  yum clean expire-cache "$@"
}

yum_Scc() {
  yum clean packages "$@"
}

yum_Sccc() {
  yum clean all "$@"
}

yum_S() {
  # shellcheck disable=SC2086
  yum install $_TOPT "$@"
}

yum_U() {
  yum localinstall "$@"
}

yum_Sii() {
  if ! command -v repoquery > /dev/null 2>&1; then
    _die "pacapt: repoquery binary does not exist in system."
  fi

  repoquery --installed --whatrequires "$@"
}
