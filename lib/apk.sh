#!/bin/bash

# Purpose: Support next-generation Alpine Linux apk package manager
# Author : Cuong Manh Le <cuong.manhle.vn@gmail.com>
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

apk_S() {
  case ${_EOPT} in
    # Download only, _translate_w gave trailing spaces
    ("fetch "*) shift
                apk fetch        -- "$@" ;;
            (*) apk add   $_TOPT -- "$@" ;;
  esac
}

apk_Sy() {
  apk update
}

apk_Suy() {
  apk update
  if [ "$#" -gt 0 ]; then
    apk add --upgrade -- "$@"
  else
    apk upgrade
  fi
}

apk_Sw() {
  apk fetch -- "$@"
}

apk_Si() {
  apk info -a -- "$@"
}

apk_Ss() {
  apk search -- "$@"
}

apk_Su() {
  apk_Suy "$@"
}

apk_Qi() {
  apk_Si "$@"
}

apk_R() {
  apk del -- "$@"
}
