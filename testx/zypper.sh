#!/bin/bash

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

_zypper_init() {
  :
}

zypper_Qc() {
  rpm -q --changelog "$@"
}

zypper_Qi() {
  zypper info "$@"
}

zypper_Ql() {
  rpm -ql "$@"
}

zypper_Qu() {
  zypper list-updates "$@"
}

zypper_Qm() {
  zypper search -si "$@" \
  | grep 'System Packages'
}

zypper_Qo() {
  rpm -qf "$@"
}

zypper_Qp() {
  rpm -qip "$@"
}

zypper_Qs() {
  zypper search --installed-only "$@"
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

zypper_Rn() {
  # Remove configuration files
  while read -r file; do
    if [[ -f "$file" ]]; then
      rm -fv "$file"
    fi
  done < <(rpm -ql "$@")

  # Now remove the package per-se
  zypper remove "$@"
}

zypper_Rs() {
  if [[ "$_TOPT" == "s" ]]; then
    zypper remove "$@" --clean-deps
  else
    _not_implemented
  fi
}

zypper_Rns() {
  # Remove configuration files
  while read -r file; do
    if [[ -f "$file" ]]; then
      rm -fv "$file"
    fi
  done < <(rpm -ql "$@")

  zypper remove "$@" --clean-deps
}

zypper_Suy() {
  zypper dup "$@"
}

zypper_Sy() {
  zypper refresh "$@"
}

zypper_Sl() {
  if [[ $# -eq 0 ]]; then
    zypper pa -R
  else
    zypper pa -r "$@"
  fi
}

zypper_Ss() {
  zypper search "$@"
}

zypper_Su() {
  zypper --no-refresh dup "$@"
}

zypper_Sc() {
  zypper clean "$@"
}

zypper_Scc() {
  zypper clean "$@"
}

zypper_Sccc() {
  # Not way to do this in zypper
  _not_implemented
}

zypper_Si() {
  zypper info --requires "$@"
}

zypper_Sii() {
  # Ugly and slow, but does the trick
  local packages=

  packages="$(zypper pa -R | cut -d \| -f 3 | tr -s '\n' ' ')"
  for package in $packages; do
    zypper info --requires "$package" \
    | grep -q "$@" && echo $package
  done
}

zypper_S() {
  zypper install $_TOPT "$@"
}

zypper_Sw() {
  zypper install --download-only "$@"
}

zypper_U() {
  zypper install "$@"
}
