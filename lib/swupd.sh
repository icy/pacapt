#!/usr/bin/env sh

# Purpose: Clear Linux support
# Author : Dmitry Kudriavtsev <me@dk0.us>
# License: Fair license (http://www.opensource.org/licenses/fair)
# Source : http://github.com/dkudriavtsev/pacapt/

# Copyright (C) 2014 Dmitry Kudriavtsev
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works is
# notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.

_swupd_init() {
  :
}

swupd_Q() {
  swupd bundle-list "$@"
}

swupd_Qi() {
  swupd bundle-info "$@"
}

swupd_Qk() {
  swupd verify "$@"
}

swupd_Qo() {
  if cmd="$(command -v -- "$@")"; then
    swupd search "$cmd"
  else
    swupd search "$@"
  fi
}

swupd_Qs() {
  swupd search "$@"
}

swupd_R() {
  swupd bundle-remove "$@"
}

swupd_Suy() {
  swupd update
}

swupd_Su() {
  swupd update
}

swupd_Sy() {
  swupd update
}

swupd_Ss() {
  swupd search "$@"
}

swupd_S() {
  swupd bundle-add "$@"
}
