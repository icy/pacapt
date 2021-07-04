#!/usr/bin/env sh

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

# in -Sy
_homebrew_init() {
  :
}

# in -S nano

# in ! command -v nano
# ou bin/nano

# in ! nano --version
# ou GNU nano

# in -Qi
# ou kegs.*files

# in -Qi nano
# ou License: GPL
# ou replacement for the Pico
homebrew_Qi() {
  brew info "$@"
}

# NOTE: `Ql` will print list of packages! This is a `brew` feature
# NOTE:  $ brew list       # list all packages
# NOTE:  $ brew list nano  # list all nano's files
# NOTE: `homebrew` detects the stdout stream and modifies the result
# in -Ql
# ou ^nano.* bin/nano

# in -Qql
# ou ^([^[:space:]])*bin/nano

# in -Ql nano
# ou bin/nano
# ou share/info/nano.info
homebrew_Ql() {
  if [ "$#" -ge 1 ]; then
    brew list "$@"
  else
    if [ -z "$_TOPT" ]; then
      for package in $(brew list); do
        brew list "$package" \
        | PACKAGE="$package" awk '{printf("%s %s\n", ENVIRON["PACKAGE"], $0)}'
      done
    elif [ "$_TOPT" = "q" ]; then
      for package in $(brew list); do
        brew list "$package"
      done
    fi
  fi
}

# Please note that `brew list` lists all packages,
# but `brew list nano` lists all files from `nano`.
# Hence we need to provide `grep` command here.
# FIXME: Also search in ... package description
# FIXME: `homebrew search` does search online/locally (both!)
# FIXME: and it may provide more options. We don't use them now.
# in -Qs
# ou ^nano
homebrew_Qs() {
  if [ -z "$_TOPT" ]; then
    local_flags="--versions"
  else
    local_flags=""
  fi
  brew list $local_flags | grep "${@:-.}"
}

# TODO # homebrew_Qo() {
# TODO #   local_pkg=
# TODO #   local_prefix=
# TODO #   local_cellar=
# TODO #
# TODO #   # FIXME: What happens if the file is not exectutable?
# TODO #   cd "$(dirname -- "$(command -v "$@")")" || return
# TODO #
# TODO #   local_pkg="$(pwd -P)/$(basename -- "$@")"
# TODO #   local_prefix="$(brew --prefix)"
# TODO #   local_cellar="$(brew --cellar)"
# TODO #
# TODO #   for package in "${local_cellar}"/*; do
# TODO #     files=(${package}/*/${local_pkg/#${local_prefix}\//})
# TODO #     if [[ -e "${files[${#files[@]} - 1]}" ]]; then
# TODO #       echo "${package/#${local_cellar}\//}"
# TODO #       break
# TODO #     fi
# TODO #   done
# TODO # }

# in -Qo -1
# ou ^Date:

# in -Qo nano -1
# ou ^Date:
homebrew_Qc() {
  brew log "$@"
}

# FIXME: The result may vary and we don't have a fixed expectation
homebrew_Qu() {
  brew outdated "$@"
}

# in -Q
# ou nano [0-9].[0-9]
# in -Qq
# ou nano
# in -Qq nano
# ou nano
homebrew_Q() {
  if [ -z "$_TOPT" ]; then
    local_flags="--versions"
  else
    local_flags=""
  fi
  brew list $local_flags "$@"
}

# homebrew_Rs() {
#   _require_programs join sort
#
#   if [ $# -eq 0 ]; then
#     _die "pacapt(homebrew_Rs) missing arguments."
#   fi
#
#   for _target in "$@"; do
#     brew rm "$_target"
#
#     while [ "$(join <(sort <(brew leaves)) <(sort <(brew deps $_target)))" != "" ]
#     do
#       brew rm $(join <(sort <(brew leaves)) <(sort <(brew deps $_target)))
#     done
#   done
# }

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

  local_dcache

  local_dcache="$(brew --cache)"
  case "$local_dcache" in
  ""|"/"|" ")
    _error "pacapt(homebrew_Sccc): Unable to delete '$local_dcache'."
    ;;

  *)
    # FIXME: This can be wrong. But it's an easy way
    # FIXME: to avoid some warning from #shellcheck.
    # FIXME: Please note that, $_dcache is not empty now.
    rm -rf "${local_dcache:-/x/x/x/x/x/x/x/x/x/x/x//x/x/x/x/x/}/"
    ;;
  esac
}

homebrew_S() {
  # shellcheck disable=SC2086
  2>&1 brew install $_TOPT "$@" \
  | awk '{print; if ($0 ~ /brew cask install/) { exit(126); }}'
  if [ "${?}" = 126 ]; then
    _warn "Failed to install package, now trying with 'brew cask' as suggested..."
    # shellcheck disable=SC2086
    brew cask install $_TOPT "$@"
  fi
}
