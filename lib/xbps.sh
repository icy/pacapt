#!/bin/sh

# Purpose: Void Linux support
# Author : lasers
# License: Fair license (http://www.opensource.org/licenses/fair)
# Source : http://github.com/icy/pacapt/

# Copyright (C) 2017 lasers
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works is
# notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.

_xbps_init() {
  :
 }

_xbps_pkgs_only() {
  echo ="$(xbps-query --list-pkgs \
  | awk '{ print $2 }' \
  | xargs -n1 xbps-uhelper getpkgname \
  | fmt)"
}

xbps_D_asexplicit() {
  # how do we use this? # pacman -D --asexplicit
  xbps-pkgdb -m manual "$@"
}

xbps_Q() {
  PKGS="$@"
  if [ -z "$PKGS" ]
  then
    xbps-query --list-pkgs
  else
    for PKG in $PKGS
    do
      xbps-query --list-pkgs | grep -i "$PKG"
    done
  fi
}

# untested + blocked: function not supported?
xbps_Qet() {
  PKGS="$@"
  if [ -z "$PKGS" ]
  then
    xbps-query -m
  else
    for PKG in $PKGS
    do
      xbps-query -m | grep -i "$PKG"
    done
  fi
}

xbps_Qi() {
  PKGS="$@"
  RED="$(tput setaf 9)"
  RESET="$(tput sgr0)"
  if [ -z "$PKGS" ]
  then
    PKGS="$(_xbps_pkgs_only)"
  fi
  for PKG in $PKGS
  do
    xbps-query --show "$PKG"
	if [ "$?" -eq 0 ]
	then
	  echo
	else
	  echo "${RED}error: ${RESET}package '$PKG' was not found"
	fi
  done
}

xbps_Ql() {
  PKGS="$@"
  CYAN="$(tput setaf 14)"
  RESET="$(tput sgr0)"
  if [ -z "$PKGS" ]
  then
    PKGS="$(_xbps_pkgs_only)"
  fi
  for PKG in $PKGS
  do
    xbps-query --files "$PKG" | sed -e "s/^/${CYAN}${PKG} ${RESET}/g"
  done
}

xbps_Qo() {
  PKGS="$@"
  RED="$(tput setaf 9)"
  RESET="$(tput sgr0)"
  for PKG in $PKGS
  do
    if [ -f "$PKG" ]
    then
      xbps-query --ownedby "$PKG"
    elif which $PKG &>/dev/null
    then
      xbps-query --ownedby "$(which $PKG)"
    else
      echo "${RED}error: ${RESET}failed to find '$PKG' in PATH: No such file or directory"
    fi
  done
}

xbps_Qp() {
  _not_implemented
}

xbps_Qs() {
  if [ ! -z "$@" ]
  then
    xbps-query --search "$@"
  else
    xbps-query --search ''''
  fi
}

xbps_Qu() {
  xbps-install --sync --update --dry-run "$@"
}

xbps_R() {
  xbps-remove "$@"
}

xbps_Rn() {
  xbps-remove --recursive "$@"
}

xbps_Rs() {
  xbps-remove --recursive "$@"
}

xbps_Rns() {
  xbps-remove --recursive "$@"
}

xbps_S() {
  xbps-install --force $_TOPT "$@"
}

xbps_S_asdeps() {
  # how do we use this? pacman -S --asdeps
  xbps-pkgdb -m auto "$@"
}

xbps_Sc() {
  xbps-remove --clean-cache "$@"
}

xbps_Scc() {
  xbps-remove --remove-orphans "$@"
}

xbps_Sccc() {
  xbps-remove --clean-cache --remove-orphans "$@"
}

xbps_Si() {
  PKGS="$@"
  if [ -z "$PKGS" ]
  then
    PKGS="$(_xbps_pkgs_only)"
  fi
  for PKG in $PKGS
  do
	xbps-query --repository --deps "$PKG"
	echo
  done
}

xbps_Sii() {
  xbps-query --repository --revdeps "$@"
}

xbps_Ss() {
  xbps-query --repository --search "$@"
}

xbps_Su() {
  xbps-install --update "$@"
}

xbps_Suy() {
  xbps-install --sync --update $_TOPT "$@"
}

xbps_Sw() {
  _not_implemented
}

xbps_Sy() {
  xbps-install --sync "$@"
}

xbps_U() {
  _not_implemented
}
