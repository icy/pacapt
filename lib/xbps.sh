#!/usr/bin/env sh

# Purpose: Void Linux support
# Author : Connor Sample
# License: Fair license (http://www.opensource.org/licenses/fair)
# Source : http://github.com/icy/pacapt/

# Copyright (C) 2021 Connor Sample
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works is
# notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.

_xbps_init() {
  :
}

xbps_Q() {
  xbps-query -l
}

xbps_Qe() {
  xbps-query -m
}

xbps_Qi() {
  xbps-query -s "$@"
}

xbps_Ql() {
  xbps-query -f "$@"
}

xbps_Qo() {
  xbps-query -o "$@"
}

xbps_Qs() {
  xbps-query -s "$@"
}

xbps_S() {
  xbps-install "$@"
}

xbps_Ss() {
  xbps-query -Rs "$@"
}

xbps_Su() {
  xbps-install -u
}

xbps_Sy() {
  xbps-install -S
}

xbps_Suy() {
  xbps-install -Su
}

xbps_R() {
  xbps-remove "$@"
}

xbps_Scc() {
  xbps-remove -O
}
