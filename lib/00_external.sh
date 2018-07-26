#!/usr/bin/env bash

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
  local _tmp_name=
  local _pacman=

  _tmp_name="${BASH_SOURCE[0]:-?}"
  if [[ "$_tmp_name" == "?" ]]; then
    _error "Unable to get script name."
    return 1
  fi

  _tmp_name="${_tmp_name##*/}" # base name (remove everything before the last `/`)
  _tmp_name="${_tmp_name%.*}"  # remove extension if any (remove everything from the last `.`)
  _pacman="${_tmp_name##*-}"   # remove every thing before the last `-`

  if grep -Eq -e ":$_pacman[[:space:]]*" <<< "$_SUPPORTED_EXTERNALS"; then
    export _PACMAN="$_pacman"
    return 0
  else
    export _PACMAN=""
    return 1
  fi
}
