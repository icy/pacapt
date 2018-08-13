#!/usr/bin/env bash

# Purpose : tlmgr support
# Author  : Antony Lee
# License : MIT
# Date    : July 26, 2018

# Copyright (C) 2018 Antony Lee
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works is
# notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.

_tlmgr_init() {
  :
}

tlmgr_Qi() {
  tlmgr info --only-installed "$@"
}

tlmgr_Qk() {
  tlmgr check files
}

tlmgr_Ql() {
  tlmgr info --only-installed --list "$@"
}

tlmgr_R() {
  tlmgr remove "$@"
}

tlmgr_S() {
  tlmgr install "$@"
}

tlmgr_Si() {
  tlmgr info "$@"
}

tlmgr_Sl() {
  tlmgr info
}

tlmgr_Ss() {
  tlmgr search --global "$@"
}

tlmgr_Suy() {
  tlmgr update --all
}

tlmgr_U() {
  tlmgr install --file "$@"
}
