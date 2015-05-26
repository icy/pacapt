# Purpose: A wrapper for all Unix package managers
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

set -u
unset GREP_OPTIONS
: "${PACAPT_DEBUG=}"

_POPT="" # primary operation
_SOPT="" # secondary operation
_TOPT="" # options for operations
_EOPT="" # extra options (directly given to package manager)
_PACMAN="" # name of the package manager

_PACMAN_detect \
|| _die "'pacapt' doesn't support your package manager."

if [[ -z "$PACAPT_DEBUG" ]]; then
  [[ "$_PACMAN" != "pacman" ]] \
  || exec "/usr/bin/pacman" "$@"
elif [[ "$PACAPT_DEBUG" != "auto" ]]; then
  _PACMAN="$PACAPT_DEBUG"
fi

while :; do
  _args="${1-}"

  [[ "${_args:0:1}" == "-" ]] || break

  case "${_args}" in
  "--help")
    _help
    exit 0
    ;;
  "-"|"--")
    break
    ;;
  esac

  i=1
  while [[ "$i" -lt "${#_args}" ]]; do
    _opt="${_args:$i:1}"
    (( i ++ ))

    case "$_opt" in
    h)
      _help
      exit 0
      ;;
    V)
      _print_pacapt_version $PACAPT_VERSION;
      exit 0
      ;;
    P)
      _print_supported_operations $_PACMAN
      exit 0
      ;;

    Q|S|R|U)
      if [[ -n "$_POPT" && "$_POPT" != "$_opt" ]]; then
        _error "Only one operation may be used at a time"
        exit 1
      fi
      _POPT="$_opt"
      ;;

    # Comment 2015 May 26th: This part deals with the 2nd option.
    # Most of the time, there is only one 2nd option. But some
    # operation may need extra and/or duplicate (e.g, Sy <> Syy).
    #
    # See also
    #
    # * https://github.com/icy/pacapt/issues/13
    #
    #   This implementation works, but with a bug. #Rsn works
    #   but #Rns is translated to #Rn (incorrectly.)
    #   Thanks Huy-Ngo for this nice catch.
    #
    # FIXME: Please check pacman(8) to see if they are really 2nd operation
    #
    s|l|i|p|o|m|n)
      if [[ "$_SOPT" == '' ]]; then
        _SOPT="$_opt"
        continue
      fi

      # Understand it:
      # If there is already an option recorded, the incoming option
      # will come and compare itself with known one.
      # We have a table
      #
      #     known one vs. incoming ? | result
      #                <             | one-new
      #                =             | one
      #                >             | new-one
      # Let's say, after this step, the 3rd option comes (named X),
      # and the current result is "a-b". We have a table
      #
      #    a(b) vs. X  | result
      #         <      | aX (b dropped)
      #         =      | ab (X discarded)
      #         >      | Xa (b dropped)
      #
      # In any case, the first one matters.
      #
      if [[ "${_SOPT:0:1}" < "$_opt" ]]; then
        _SOPT="${_SOPT:0:1}$_opt"
      elif [[ "${_SOPT:0:1}" == "$_opt" ]]; then
        _SOPT="$_SOPT"
      else
        _SOPT="$_opt${_SOPT:0:1}"
      fi

      ;;

    q)
      _TOPT="$_opt" ;; # Thanks to James Pearson

    u)
      if [[ "${_SOPT:0:1}" == "y" ]]; then
        _SOPT="uy"
      else
        _SOPT="u"
      fi
      ;;

    y)
      if [[ "${_SOPT:0:1}" == "u" ]]; then
        _SOPT="uy"
      else
        _SOPT="y"
      fi
      ;;

    c)
      if [[ "${_SOPT:0:2}" == "cc" ]]; then
        _SOPT="ccc"
      elif [[ "${_SOPT:0:1}" == "c" ]]; then
        _SOPT="cc"
      else
        _SOPT="$_opt"
      fi
      ;;

    w)
      _tranlate_w
      ;;

    v)
      _EOPT="-v"
      ;;

    *)
      _die "pacapt: Unknown option '$_opt'."
      ;;
    esac
  done

  shift

  if [[ -n "$_POPT" && -n "$_SOPT" ]]; then
    if [[ -z "$_TOPT" && "${1-}" == "-w" ]]; then
      shift
      _tranlate_w
    fi
    break
  # Don't have anything from the first argument. Something wrong.
  elif [[ -z "${_POPT}${_SOPT}${_TOPT}${_EOPT}" ]]; then
    break
  fi
done

[[ -n "$_POPT" ]] \
|| _die "pacapt: Please specify a primary operation (Q, S, R, U)."

_validate_operation "${_PACMAN}_${_POPT}${_SOPT}" \
|| {
  _not_implemented
  exit 1
}

# pacman man page (examples) says:
#   "pacman -Syu gpm = Update package list, upgrade all packages,
#    and then install gpm if it wasn't already installed."
#
# Instead, just disallow specific packages, as (ex-)yum users likely
# expect to just update/upgrade one package (and its dependencies)
# and apt-get and pacman have no way to do this.
#
if [[ -n "$@" ]]; then
  case "${_POPT}${_SOPT}" in
  "Su"|"Sy"|"Suy")
    echo 1>&2 "WARNING ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    echo 1>&2 "  The -Sy/u options refresh and/or upgrade all packages."
    echo 1>&2 "  To install packages as well, use separate commands:"
    echo 1>&2
    echo 1>&2 "    $0 -S$_SOPT; $0 -S $@"
    echo 1>&2 "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
  esac
fi

if [[ -n "$PACAPT_DEBUG" ]]; then
  echo "pacapt: $_PACMAN, p=$_POPT, s=$_SOPT, t=$_TOPT, e=$_EOPT"
  echo "pacapt: execute '${_PACMAN}_${_POPT}${_SOPT} $_EOPT $@'"
else
  "_${_PACMAN}_init"
  "${_PACMAN}_${_POPT}${_SOPT}" $_EOPT "$@"
fi
