#!/usr/bin/env sh

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
  if cmd="$(command -v -- "$@")"; then
    rpm -qf "$cmd"
  else
    rpm -qf "$@"
  fi
}

zypper_Qp() {
  rpm -qip "$@"
}

zypper_Qs() {
  zypper search --search-descriptions --installed-only "$@" \
  | {
    if [ "$_TOPT" = "q" ]; then
      awk -F ' *| *' '/^[a-z]/ {print $3}'
    else
      cat
    fi
  }
}

zypper_Q() {
  if [ "$_TOPT" = "q" ]; then
    zypper search -i "$@" \
    | grep ^i \
    | awk '{print $3}'
  elif [ -z "$_TOPT" ]; then
    zypper search -i "$@"
  else
    _not_implemented
  fi
}

zypper_Rs() {
  if [ "$_TOPT" = "s" ]; then
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
  rpm -ql "$@" \
  | while read -r file; do
    if [ -f "$file" ]; then
      rm -fv "$file"
    fi
  done

  # Now remove the package per-se
  zypper remove "$@"
}

zypper_Rns() {
  # Remove configuration files
  rpm -ql "$@" \
  | while read -r file; do
    if [ -f "$file" ]; then
      rm -fv "$file"
    fi
  done

  zypper remove "$@" --clean-deps
}

zypper_Suy() {
  zypper dup "$@"
}

zypper_Sy() {
  zypper refresh "$@"
}

zypper_Sl() {
  if [ $# -eq 0 ]; then
    zypper pa -R
  else
    zypper pa -r "$@"
  fi
}

zypper_Sg() {
  if [ $# -gt 0 ]; then
    zypper info "$@"
  else
    zypper patterns
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
  if [ $# -eq 0 ]; then
    _error "Missing some package name."
    return 1
  fi
  _not_implemented
  return

  # TOO SLOW ! # # Ugly and slow, but does the trick
  # TOO SLOW ! # local_packages="$( \
  # TOO SLOW ! #   zypper pa --installed-only -R \
  # TOO SLOW ! #   | grep -E '^[a-z]' \
  # TOO SLOW ! #   | cut -d \| -f 3 | sort -u)"
  # TOO SLOW ! #
  # TOO SLOW ! # for package in $local_packages; do
  # TOO SLOW ! #   zypper info --requires "$package" \
  # TOO SLOW ! #   | grep -q "$@" && echo "$package"
  # TOO SLOW ! # done
}

zypper_S() {
  # shellcheck disable=SC2086
  zypper install $_TOPT "$@"
}

zypper_U() {
  zypper install "$@"
}
