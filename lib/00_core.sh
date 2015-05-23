# Purpose: Provide some basic functions
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

_error() {
  echo >&2 "Error: $@"
  return 1
}

_die() {
  echo >&2 "$@"
  exit 1
}

_not_implemented() {
  echo >&2 "${_PACMAN}: '${_POPT}:${_SOPT}:${_TOPT}' operation is invalid or not implemented."
  return 1
}

_removing_is_dangerous() {
  echo >&2 "${_PACMAN}: removing with '$*' is too dangerous"
  return 1
}

# Detect package type from /etc/issue
# FIXME: Using new `issue` file (location)
_issue2pacman() {
  local _pacman

  _pacman="$1"; shift

  grep -qis "$@" /etc/issue \
  && _PACMAN="$_pacman" && return

  grep -qis "$@" /etc/os-release \
  && _PACMAN="$_pacman" && return
}

# Detect package type
_PACMAN_detect() {
  _issue2pacman pacman "Arch Linux" && return
  _issue2pacman dpkg "Debian GNU/Linux" && return
  _issue2pacman dpkg "Ubuntu" && return
  _issue2pacman cave "Exherbo Linux" && return
  _issue2pacman yum "CentOS" && return
  _issue2pacman yum "Red Hat" && return
  _issue2pacman yum "Fedora" && return
  _issue2pacman zypper "SUSE" && return
  _issue2pacman pkg_tools "OpenBSD" && return
  _issue2pacman pkg_tools "Bitrig" && return

  [[ -z "$_PACMAN" ]] || return

  # Prevent a loop when this script is installed on non-standard system
  if [[ -x "/usr/bin/pacman" ]]; then
    grep -q "$FUNCNAME" '/usr/bin/pacman' >/dev/null 2>&1
    [[ $? -ge 1 ]] && _PACMAN="pacman" \
    && return
  fi

  [[ -x "/usr/bin/apt-get" ]] && _PACMAN="dpkg" && return
  [[ -x "/usr/bin/cave" ]] && _PACMAN="cave" && return
  [[ -x "/usr/bin/yum" ]] && _PACMAN="yum" && return
  [[ -x "/opt/local/bin/port" ]] && _PACMAN="macports" && return
  [[ -x "/usr/bin/emerge" ]] && _PACMAN="portage" && return
  [[ -x "/usr/bin/zypper" ]] && _PACMAN="zypper" && return
  [[ -x "/usr/sbin/pkg" ]] && _PACMAN="pkgng" && return
  # make sure pkg_add is after pkgng, FreeBSD base comes with it until converted
  [[ -x "/usr/sbin/pkg_add" ]] && _PACMAN="pkg_tools" && return

  command -v brew >/dev/null && _PACMAN="homebrew" && return

  return 1
}

# Translate -w option. Please note this is only valid when installing
# a package from remote, aka. when '-S' operation is performed.
_translate_w() {
  case "$_PACMAN" in
  "dpkg")
    _TOPT="-d"
    ;;
  "cave")
    _TOPT="-f"
    ;;

  "yum")
    _TOPT="--downloadonly"
    if ! [[ $(rpm -qa --pipe "grep downloadonly") ]]; then
      _error "'yum-downloadonly' or 'yum-plugin-downloadonly' package is required when '-w' is used."
      exit 1
    fi
    ;;

  "macports")
    _TOPT="fetch"
    ;;

  "portage")
    _TOPT="--fetchonly"
    ;;

  "zypper")
    _TOPT="--download-only"
    ;;

  "pkgng")
    _TOPT="fetch"
    ;;

  *)
    _TOPT=""
    return 1
    ;;
  esac
}

_print_supported_operations() {
  local _pacman="$1"
  echo -n "pacapt: available operations:"
  grep -E "^${_pacman}_[^ \t]+\(\)" "$0" \
  | awk -F '(' '{print $1}' \
  | sed -e "s/${_pacman}_//g" \
  | while read O; do
      echo -n " $O"
    done
  echo
}

_print_pacapt_version() {
  cat <<EOF
pacapt version '${1:-unknown}'

Copyright (C) 2010 - $(date +%Y) Anh K. Huynh et al.

Usage of the works is permitted provided that this
instrument is retained with the works, so that any
entity that uses the works is notified of this instrument.

DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.
EOF
}
