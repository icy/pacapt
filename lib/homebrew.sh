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
#
# NOTE:   $ brew list       # list all packages
# NOTE:   $ brew list nano  # list all nano's files (short list)
#
# NOTE: `homebrew` detects the stdout stream and modifies the result.
# NOTE: For example, `homebrew list nano` only gives short output
# NOTE: by default, but when being used with pipe it will print all
# NOTE: files (which can be very slow/long)
#
# NOTE:   $ brew list nano | cat  # list all files (full list)
#

# in -Ql
# ou ^nano.* bin/nano

# in -Qql
# ou ^([^[:space:]])*bin/nano

# in -Ql nano
# ou bin/nano
# ou share/info/nano.info
#
homebrew_Ql() {
  local_casks=
  local_forumlas=

  if [ $# -eq 0 ]; then
    local_casks="$(brew list --casks)"
    local_forumlas="$(brew list --formula)"
  else
    # FIXME: this awk is not perfect!
    local_casks="$(brew list --casks | LIST="$*" awk '$0 ~ ENVIRON["LIST"]')"
    local_forumlas="$(brew list --formula | LIST="$*" awk '$0 ~ ENVIRON["LIST"]')"
  fi

  if [ -z "$_TOPT" ]; then
    for package in $local_casks; do
      brew list --cask "$package" \
      | grep ^/ \
      | PACKAGE="$package" awk '{printf("%s %s\n", ENVIRON["PACKAGE"], $0)}'
    done
    for package in $local_forumlas; do
      brew list --formula "$package" \
      | PACKAGE="$package" awk '{printf("%s %s\n", ENVIRON["PACKAGE"], $0)}'
    done
  elif [ "$_TOPT" = "q" ]; then
    for package in $local_casks; do
      brew list --cask "$package" \
      | grep ^/
    done
    for package in $local_forumlas; do
      brew list --formula "$package"
    done
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
  # shellcheck disable=SC2086
  brew list $local_flags | grep "${@:-.}"
}

# FIXME # homebrew_Qo() {
# FIXME #   local_pkg=
# FIXME #   local_prefix=
# FIXME #   local_cellar=
# FIXME #
# FIXME #   # FIXME: What happens if the file is not exectutable?
# FIXME #   cd "$(dirname -- "$(command -v "$@")")" || return
# FIXME #
# FIXME #   local_pkg="$(pwd -P)/$(basename -- "$@")"
# FIXME #   local_prefix="$(brew --prefix)"
# FIXME #   local_cellar="$(brew --cellar)"
# FIXME #
# FIXME #   for package in "${local_cellar}"/*; do
# FIXME #     files=(${package}/*/${local_pkg/#${local_prefix}\//})
# FIXME #     if [[ -e "${files[${#files[@]} - 1]}" ]]; then
# FIXME #       echo "${package/#${local_cellar}\//}"
# FIXME #       break
# FIXME #     fi
# FIXME #   done
# FIXME # }

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
  # shellcheck disable=SC2086
  brew list $local_flags --formula "$@"
  # shellcheck disable=SC2086
  brew list $local_flags --cask "$@"
}

# FIXME # homebrew_Rs() {
# FIXME #   _require_programs join sort
# FIXME #
# FIXME #   if [ $# -eq 0 ]; then
# FIXME #     _die "pacapt(homebrew_Rs) missing arguments."
# FIXME #   fi
# FIXME #
# FIXME #   for _target in "$@"; do
# FIXME #     brew rm "$_target"
# FIXME #
# FIXME #     while [ "$(join <(sort <(brew leaves)) <(sort <(brew deps $_target)))" != "" ]
# FIXME #     do
# FIXME #       brew rm $(join <(sort <(brew leaves)) <(sort <(brew deps $_target)))
# FIXME #     done
# FIXME #   done
# FIXME # }

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

# NOTE: New version of homebrew will automatically invoke `brew cask install`
# NOTE: if formula is not available.
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
