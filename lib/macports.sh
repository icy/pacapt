#!/bin/bash

# Purpose: Macports support
# Author : 10sr
# License: Fair license (http://www.opensource.org/licenses/fair)
# Source : http://github.com/icy/pacapt/

# Copyright (C) 2010 - 2014 10sr
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works is
# notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.

_macports_init() {
  export PASSTHROUGH=port
}

macports_Ql() {
  port contents "$@"
}

macports_Qo() {
  port provides "$@"
}

macports_Qc() {
  port log "$@"
}

macports_Qu() {
  port outdated "$@"
}

macports_Rs() {
  port uninstall --follow-dependencies "$@"
}

macports_R() {
  port uninstall "$@"
}

macports_Si() {
  port info "$@"
}

macports_Suy() {
  port selfupdate \
  && port upgrade outdated "$@"
}

macports_Su() {
  port upgrade outdate "$@"
}

# FIXME: update or sync?
macports_Sy() {
  port selfupdate "$@"
}

macports_Ss() {
  port search "$@"
}

macports_Sc() {
  port clean --all inactive "$@"
}

macports_Scc() {
  port clean --all installed "$@"
}

macports_S() {
  port install "$@"
}

macports_Sw() {
  shift; # Remove `fetch`
  port patch "$@"
}
