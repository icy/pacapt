#!/usr/bin/env sh

# Purpose: Support next-generation Alpine Linux apk package manager
# Author : Carl X. Su <bcbcarl@gmail.com>
#          Cuong Manh Le <cuong.manhle.vn@gmail.com>
# License: Fair license (http://www.opensource.org/licenses/fair)
# Source : http://github.com/icy/pacapt/

# Copyright (C) 2016 CuongLM
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works is
# notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.

_apk_init() {
  :
}

# apk_Q may _not_implemented
# FIXME: Need to support a small list of packages
apk_Q() {
  case "$_TOPT" in
  "")
    apk list --installed "$@"
    ;;
  "q")
    apk info
    ;;
  *)
    _not_implemented
    ;;
  esac
}

apk_Qe() {
  apk info | grep -x -f /etc/apk/world
}

apk_Qi() {
  if [ "$#" -eq 0 ]; then
    # shellcheck disable=SC2046
    apk info --all $(apk info)
    return
  fi

  # shellcheck disable=2086
  if apk info --installed $_TOPT "$@"; then
    # shellcheck disable=2086
    apk info --all $_TOPT "$@"
  else
    >&2 echo ":: Error: Package not installed: '${*}'"
  fi
}

apk_Ql() {
  if [ "$#" -eq 0 ]; then
    packages="$(apk info)"
  else
    packages="$*"
  fi

  for pkg in ${packages:-}; do
    apk info --contents "$pkg" \
    | awk -v pkg="$pkg" '/\// {printf("%s %s\n", pkg, $0)}'
  done \
  | {
    case $_TOPT in
    "q") awk '{print $NF}';;
    "")  cat ;;
    *)   _not_implemented ; exit 1;;
    esac
  }
}

apk_Qo() {
  if cmd="$(command -v -- "$@")"; then
    apk info --who-owns -- "$cmd"
  else
    apk info --who-owns -- "$@"
  fi
}

apk_Qs() {
  # shellcheck disable=2086
  apk list --installed $_TOPT "*${*}*"
}

apk_Qu() {
  apk version -l '<'
}

apk_R() {
  # shellcheck disable=2086
  apk del $_TOPT -- "$@"
}

apk_Rn() {
  # shellcheck disable=2086
  apk del --purge $_TOPT -- "$@"
}

apk_Rns() {
  # shellcheck disable=2086
  apk del --purge -r $_TOPT -- "$@"
}

apk_Rs() {
  # shellcheck disable=2086
  apk del -r $_TOPT -- "$@"
}

apk_S() {
  # shellcheck disable=2086
  case ${_EOPT} in
    # Download only
     (fetch*) shift
              apk fetch $_TOPT "$@" ;;
          (*) apk add   $_TOPT "$@" ;;
  esac
}

apk_Sc() {
  apk cache -v clean
}

apk_Scc() {
  rm -rf /var/cache/apk/*
}

apk_Sccc() {
  apk_Scc
}

apk_Si() {
  # shellcheck disable=2086
  apk info $_TOPT "$@"
}

apk_Sii() {
  apk info -r -- "$@"
}

apk_Sl() {
  apk search -v -- "$@"
}

apk_Ss() {
  apk_Sl "$@"
}

apk_Su() {
  apk upgrade
}

apk_Suy() {
  if [ "$#" -gt 0 ]; then
    apk add -U -u -- "$@"
  else
    apk upgrade -U -a
  fi
}

apk_Sy() {
  apk update
}

apk_U() {
  # shellcheck disable=2086
  apk add --allow-untrusted $_TOPT -- "$@"
}
