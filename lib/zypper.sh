# Purpose: OpenSUSE support
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

zypper_Qi() {
  zypper info "$@"
}

zypper_Qu() {
  zypper list-updates "$@"
}

zypper_Qm() {
  zypper search -si "$@" \
  | grep 'System Packages'
}

zypper_Q() {
  if [[ "$_TOPT" == "q" ]]; then
    zypper search -i "$@" \
    | grep ^i \
    | awk '{print $3}'
  elif [[ "$_TOPT" == "" ]]; then
    zypper search -i "$@"
  else
    _not_implemented
  fi
}

zypper_Rs() {
  if [[ "$_TOPT" == "s" ]]; then
    zypper remove "$@" --clean-deps
  else
    _not_implemented
  fi
}

zypper_R() {
  zypper remove "$@"
}

zypper_Rs() {
  if [[ "$_TOPT" == "s" ]]; then
    zypper remove "$@" --clean-deps
  else
    _not_implemented
  fi
}

zypper_Suy() {
  zypper dup "$@"
}

zypper_Sy() {
  zypper refresh "$@"
}

zypper_Ss() {
  zypper search "$@"
}

zypper_Sc() {
  zypper clean "$@"
}

zypper_Scc() {
  zypper clean "$@"
}

zypper_S() {
  zypper install $_TOPT "$@"
}

zypper_U() {
  zypper install "$@"
}
