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
}

# Detect package type from /etc/issue
# FIXME: Using new `issue` file (location)
_issue2pacman() {
  local _pacman="$1"
  shift
  grep -qis "$@" /etc/issue \
  && _PACMAN="$_pacman"
}

# Detect package type
_PACMAN_detect() {
  _issue2pacman pacman "Arch Linux" && return
  _issue2pacman dpkg "Debian GNU/Linux" && return
  _issue2pacman dpkg "Ubuntu" && return
  _issue2pacman yum "CentOS" && return
  _issue2pacman yum "Red Hat" && return
  _issue2pacman yum "Fedora" && return
  _issue2pacman zypper "SUSE" && return

  [[ -z "$_PACMAN" ]] || return

  # Prevent a loop when this script is installed on non-standard system
  if [[ -x "/usr/bin/pacman" ]]; then
    grep -q "$FUNCNAME" '/usr/bin/pacman' >/dev/null 2>&1
    [[ $? -ge 1 ]] && _PACMAN="pacman" \
    && return
  fi

  [[ -x "/usr/bin/apt-get" ]] && _PACMAN="dpkg" && return
  [[ -x "/usr/bin/yum" ]] && _PACMAN="yum" && return
  [[ -x "/opt/local/bin/port" ]] && _PACMAN="macports" && return
  [[ -x "/usr/bin/emerge" ]] && _PACMAN="portage" && return
  [[ -x "/usr/bin/zypper" ]] && _PACMAN="zypper" && return
  [[ -x "/usr/sbin/pkg" ]] && _PACMAN="pkgng" && return

  command -v brew >/dev/null && _PACMAN="homebrew" && return

  return 1
}

# Translate -w option. Please note this is only valid when installing
# a package from remote, aka. when '-S' operation is performed.
_tranlate_w() {
  case "$_PACMAN" in
  "dpkg")
    _TOPT="-d"
    ;;

  "yum")
    _TOPT="--downloadonly"
    if ! rpm -q 'yum-downloadonly' >/dev/null 2>&1; then
      _error "'yum-downloadonly' package is required when '-w' is used."
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
