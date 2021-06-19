#!/bin/bash

# POSIX  : Ready
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
