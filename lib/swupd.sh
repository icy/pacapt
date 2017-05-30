#!/bin/bash

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

swupd_Qk() {
  swupd verify "$@"
}

swupd_Qo() {
  swupd search "$@"
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
  swupd search -i
  swupd update
}

swupd_Ss() {
  swupd search "$@"
}

swupd_S() {
  swupd bundle-add "$@"
}
