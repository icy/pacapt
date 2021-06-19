#!/usr/bin/env sh

# POSIX   : Ready
# Purpose : Provide some basic settings for external package managers
# Author  : Ky-Anh Huynh
# License : MIT
# Date    : 2018 July 26th
# Ref.    : https://github.com/icy/pacapt/issues/106

export _SUPPORTED_EXTERNALS="
  :conda
  :tlmgr
  :texlive
  :gem
  :npm
  :pip
"
readonly _SUPPORTED_EXTERNALS

_PACMAN_found_from_script_name() {
  local_tmp_name=
  local_pacman=

  local_tmp_name="${0}"
  # https://github.com/icy/pacapt/pull/161/files#r654800412
  case "$local_tmp_name" in
    *-*) : ;;
    *) return 1 ;;
  esac

  local_tmp_name="${local_tmp_name##*/}" # base name (remove everything before the last `/`)
  local_tmp_name="${local_tmp_name%.*}"  # remove extension if any (remove everything from the last `.`)
  local_pacman="${local_tmp_name##*-}"   # remove every thing before the last `-`

  if echo "$_SUPPORTED_EXTERNALS" \
    | "$GREP" -Eq -e ":${local_pacman}[[:space:]]*";
  then
    export _PACMAN="$local_pacman"
    return 0
  else
    export _PACMAN=""
    _die "Unable to guess non-system package manager ($local_pacman) from script name '$0'."
  fi
}
