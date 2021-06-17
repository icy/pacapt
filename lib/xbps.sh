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
  echo "$(xbps-query --list-pkgs \
  | awk '{ print $2 }' \
  | xargs -n1 xbps-uhelper getpkgname \
  | fmt)"
}

_xbps_inputs_only() {
    RESULT=""
    for PKG in $@
    do
        RESULT="$RESULT|$PKG"
    done
    RESULT="$(echo $RESULT | sed -e 's/^|//')"
    echo "$RESULT"
}

# PACAPT DOES NOT SUPPORT D ? // CANNOT TEST
# xbps_D() {
#   if [ "$_TOPT" == "asexplicit" ]
#   then
#     # how do we use this? # pacman -D --asexplicit
#     xbps-pkgdb -m manual "$@"
#   else
#     _not_implemented
#   fi
# }

xbps_Q() {
  # PACAPT DOES NOT SUPPORT Qe ? // CANNOT TEST
  if [[ "$_TOPT" == "e" ]]
  then
    if [ $# -eq 0 ]
    then
      xbps-query --list-manual-pkgs
    else
      RESULT="$(_xbps_inputs_only $@)"
      xbps-query --list-manual-pkgs | grep -iE "$RESULT"
    fi
  elif [[ "$_TOPT" == "" ]]; then
    if [ $# -eq 0 ]
    then
      xbps-query --list-pkgs
    else
      RESULT="$(_xbps_inputs_only $@)"
      xbps-query --list-pkgs | grep -iE "$RESULT"
    fi
  else
    _not_implemented
  fi
}

xbps_Qi() {
  PKGS="$@"
  COLOR_CYAN="$(tput setaf 14)"
  COLOR_RESET="$(tput sgr0)"
  if [ $# -eq 0 ]
  then
    PKGS="$(_xbps_pkgs_only)"
  fi
  for PKG in $PKGS
  do
    RESULT="$(xbps-query "$PKG")"
	if [ "$?" -eq 0 ]
	then
      echo "${COLOR_CYAN}name: ${COLOR_RESET}$PKG"
      xbps-query "$PKG"
	  echo
	else
	  _error "package '$PKG' was not found"
	fi
  done
}

xbps_Ql() {
  PKGS="$@"
  COLOR_CYAN="$(tput setaf 14)"
  COLOR_RESET="$(tput sgr0)"
  if [ -z "$PKGS" ]
  then
    PKGS="$(_xbps_pkgs_only)"
  fi
  for PKG in $PKGS
  do
    xbps-query --files "$PKG" | sed -e "s/^/${COLOR_CYAN}${PKG} ${COLOR_RESET}/g"
  done
}

xbps_Qo() {
  if [ $# -eq 0 ]
  then
    _error "no targets specified"
  fi
  PKGS="$@"
  for PKG in $PKGS
  do
    if [ -f "$PKG" ]
    then
      xbps-query --ownedby "$PKG"
    elif which $PKG &>/dev/null
    then
      xbps-query --ownedby "$(which $PKG)"
    else
      _error "failed to find '$PKG' in PATH: No such file or directory"
    fi
  done
}

xbps_Qp() {
  _not_implemented
}

xbps_Qs() {
  if [ $# -eq 0 ]
  then
    xbps-query --search ''''
  elif [ $# -eq 1 ]
  then
    xbps-query --search "$@"
  else
    RESULT=""
    for PKG in $@
    do
        RESULT="$(xbps-query --search '''' | grep -i "$PKG")"
    done
    echo "$RESULT"
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
  xbps-install $_TOPT "$@"
}

# THIS BELONGS IN 00_core.sh? // CANNOT TEST
# xbps_S_asdeps() {
#   # how do we use this? pacman -S --asdeps
#   xbps-pkgdb -m auto "$@"
# }

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
  COLOR_CYAN="$(tput setaf 14)"
  COLOR_RESET="$(tput sgr0)"
  if [ $# -eq 1 ]
  then
    RESULT="$(xbps-query --repository "$PKGS")"
	if [ "$?" -eq 0 ]
    then
        echo "${COLOR_CYAN}name: ${COLOR_RESET}$PKGS"
        xbps-query --repository "$PKGS"
    fi
  else
    if [ $# -eq 0 ]
    then
      PKGS="$(_xbps_pkgs_only)"
    fi
    for PKG in $PKGS
    do
      RESULT="$(xbps-query --repository "$PKG")"
	  if [ "$?" -eq 0 ]
      then
          echo "${COLOR_CYAN}name: ${COLOR_RESET}$PKG"
          xbps-query --repository "$PKG"
          echo
      fi
    done
  fi
}

xbps_Sii() {
  COLOR_CYAN="$(tput setaf 14)"
  COLOR_RESET="$(tput sgr0)"
  PKGS="$@"
  for PKG in $PKGS
  do
      RESULT="$(xbps-query --repository --revdeps "$PKG")"
	  if [ "$?" -eq 0 ]
	  then
        echo "$RESULT" \
        | xargs -n1 xbps-uhelper getpkgname \
        | xargs \
        | sed -e "s/ /  /g" -e "s/^/${COLOR_CYAN}${PKG} ${COLOR_RESET}/g"
	  else
	    _error "package '$PKG' was not found or has no dependenices"
	  fi
  done
}

xbps_Ss() {
  if [ $# -eq 1 ]
  then
    xbps-query --repository --search "$@"
  else
    RESULT="$(_xbps_inputs_only $@)"
    xbps-query --repository --search '''' | grep -iE "$RESULT"
  fi
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
