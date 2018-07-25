#!/bin/bash

# Purpose: Homebrew support
# Author : James Pearson
# License: Fair license (http://www.opensource.org/licenses/fair)
# Source : http://github.com/icy/pacapt/

# Copyright (C) 2010 - 2014 James Pearson
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works is
# notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.

_homebrew_init() {
  :
}

homebrew_Qi() {
  brew info "$@"
}

homebrew_Ql() {
  brew list "$@"
}

homebrew_Qo() {
  local pkg prefix cellar

  # FIXME: What happens if the file is not exectutable?
  cd "$(dirname -- "$(which "$@")")"
  pkg="$(pwd -P)/$(basename -- "$@")"
  prefix="$(brew --prefix)"
  cellar="$(brew --cellar)"

  for package in $cellar/*; do
    files=(${package}/*/${pkg/#$prefix\//})
    if [[ -e "${files[${#files[@]} - 1]}" ]]; then
      echo "${package/#$cellar\//}"
      break
    fi
  done
}

homebrew_Qc() {
  brew log "$@"
}

homebrew_Qu() {
  brew outdated | grep "$@"
}

homebrew_Qs() {
  brew list | grep "$@"
}

# homebrew_Q may _not_implemented
homebrew_Q() {
  if [[ "$_TOPT" == "" ]]; then
    if [[ "$*" == "" ]]; then
      brew list
    else
      brew list | grep "$@"
    fi
  else
    _not_implemented
  fi
}

# FIXME: make sure "join" does exit
# FIXME: Add quoting support, be cause "join" can fail
# homebew_Rs may _not_implemented
homebrew_Rs() {
  if [[ "$_TOPT" == "s" ]]; then
    brew rm "$@"
    brew rm $(join <(brew leaves) <(brew deps "$@"))
  else
    _not_implemented
  fi
}

homebrew_R() {
  brew remove "$@"
}

homebrew_Si() {
  brew info "$@"
}

homebrew_Suy() {
  brew update \
  && brew upgrade "$@"
}

homebrew_Su() {
  brew upgrade "$@"
}

homebrew_Sy() {
  brew update "$@"
}

homebrew_Ss() {
  brew search "$@"
}

homebrew_Sc() {
  brew cleanup "$@"
}

homebrew_Scc() {
  brew cleanup -s "$@"
}

homebrew_Sccc() {
  # See more discussion in
  #   https://github.com/icy/pacapt/issues/47

  local _dcache

  _dcache="$(brew --cache)"
  case "$_dcache" in
  ""|"/"|" ")
    _error "${FUNCNAME[0]}: Unable to delete '$_dcache'."
    ;;

  *)
    # FIXME: This is quite stupid!!! But it's an easy way
    # FIXME: to avoid some warning from #shellcheck.
    # FIXME: Please note that, $_dcache is not empty now.
    rm -rf "${_dcache:-/x/x/x/x/x/x/x/x/x/x/x//x/x/x/x/x/}/"
    ;;
  esac
}

homebrew_S() {
  brew install $_TOPT "$@"
}
