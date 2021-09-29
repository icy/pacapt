#!/usr/bin/env sh

# Purpose: A wrapper for all Unix package managers
# Author : Anh K. Huynh
# License: Fair license (http://www.opensource.org/licenses/fair)
# Source : http://github.com/icy/pacapt/

# Copyright (C) 2010 - 2021 Anh K. Huynh
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works is
# notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.

set -u

unset GREP_OPTIONS

: "${PACAPT_DEBUG=}"  # Show what will be going
: "${GREP:=grep}"     # Need to update in, e.g, _sun_tools_init
: "${AWK:=awk}"       # Need to update in, e.g, _sun_tools_init

# Dirty tricky patch for SunOS
local_requirements="$GREP $AWK"
if ! _sun_tools_init; then
  local_requirements="${local_requirements} sed"
fi

# shellcheck disable=SC2086
_require_programs $local_requirements

export PACAPT_DEBUG GREP AWK

# Shell switching, as fast as possible
if [ -z "${__PACAPT_FORKED__:-}" ]; then
  if command -v bash >/dev/null \
      && bash -c 'echo ${BASH_VERSION[*]}' \
        | "$GREP" -Ee "^[4-9]." >/dev/null 2>&1 \
    ; then

    _debug "Switching to Bash shell"
    export __PACAPT_FORKED__="yes"
    readonly __PACAPT_FORKED__

    exec bash -- "$0" "$@"
  fi
else
  # Hey, this is very awesome strick to avoid syntax issue.
  # Note: in `bocker` (github.com/icy/bocker/) we use `base64`.
  # FIXME: `source /dev/stdin` doesn't work without Bash >=4
  eval 'source /dev/stdin < <("$GREP" '^#_!_POSIX_#' "$0" | sed -e 's/^#_!_POSIX_#//')' \
  || _die "$0: Unable to load non-POSIX definitions".
fi
# /Shell switching

## Pacman stuff

_POPT=""    # primary operation
_SOPT=""    # secondary operation
_TOPT=""    # options for operations
_EOPT=""    # extra options (directly given to package manager)
            # these options will be translated by (_translate_all) method.
_PACMAN=""  # name of the package manager

_PACMAN_detect \
|| _die "'pacapt' doesn't support your package manager."

# Once we haven't switcher over `bash`, there is great chance
# the current system are missing `Bash` ; on these systems
# our library are not ready for pure-POSIX features!
if [ -z "${__PACAPT_FORKED__:-}" ]; then
  case "$_PACMAN" in
  "cave")
    _die "pacapt($_PACMAN) library is not ready for pure-POSIX features (or your Bash version is not >= 4)."
    ;;
  *)
    ;;
  esac
fi

# FIXME: If `pacman-foo` is being used, `PACAPT_DEBUG` is still overwriting that.
if [ -z "$PACAPT_DEBUG" ]; then
  [ "$_PACMAN" != "pacman" ] \
  || exec "/usr/bin/pacman" "$@"
elif [ "$PACAPT_DEBUG" != "auto" ]; then
  _PACMAN="$PACAPT_DEBUG"
fi

case "${1:-}" in
"update")     shift; set -- -Sy   "$@" ;;
"upgrade")    shift; set -- -Su   "$@" ;;
"install")    shift; set -- -S    "$@" ;;
"search")     shift; set -- -Ss   "$@" ;;
"remove")     shift; set -- -R    "$@" ;;
"autoremove") shift; set -- -Rs   "$@" ;;
"clean")      shift; set -- -Scc  "$@" ;;
esac

while :; do
  _args="${1-}"

  [ "$(printf "%.1s" "$_args")" = "-" ] || break

  case "${_args}" in
  "--help")
    _help
    exit 0
    ;;

  "--noconfirm")
    shift
    _EOPT="$_EOPT:noconfirm:"
    continue
    ;;

  "-"|"--")
    shift
    break
    ;;
  esac

  i=1
  while [ "$i" -lt "${#_args}" ]; do
    i=$(( i + 1))
    _opt="$(_string_nth "$i" "$_args")"

    case "$_opt" in
    h)
      _help
      exit 0
      ;;
    V)
      _print_pacapt_version;
      exit 0
      ;;
    P)
      _print_supported_operations "$_PACMAN"
      exit 0
      ;;

    Q|S|R|U)
      if [ -n "$_POPT" ] && [ "$_POPT" != "$_opt" ]; then
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
    e|g|i|l|m|n|o|p|s|k)
      if [ -z "$_SOPT" ]; then
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
      #                =             | one-one
      #                >             | new-one
      #
      # Let's say, after this step, the 3rd option comes (named X),
      # and the current result is "a-b". We have a table
      #
      #    a(b) vs. X  | result
      #         <      | aX (b dropped)
      #         =      | aa (b dropped)
      #         >      | Xa (b dropped)
      #
      # In any case, the first one matters.
      #
      f_SOPT="$(printf "%.1s" "$_SOPT")"
      if _string_less_than "$f_SOPT" "$_opt"; then
        _SOPT="${f_SOPT}$_opt"
      elif [ "${f_SOPT}" = "$_opt" ]; then
        _SOPT="$_opt$_opt"
      else
        _SOPT="$_opt${f_SOPT}"
      fi

      ;;

    q)
      _TOPT="$_opt" ;; # Thanks to James Pearson

    u)
      f_SOPT="$(printf "%.1s" "$_SOPT")"
      if [ "$f_SOPT" = "y" ]; then
        _SOPT="uy"
      else
        _SOPT="u"
      fi
      ;;

    y)
      f_SOPT="$(printf "%.1s" "$_SOPT")"
      if [ "${f_SOPT}" = "y" ]; then
        _SOPT="uy"
      else
        _SOPT="y"
      fi
      ;;

    c)
      if [ "$(printf "%.2s" "$_SOPT")" = "cc" ]; then
        _SOPT="ccc"
      elif [ "$(printf "%.1s" "$_SOPT")" = "c" ]; then
        _SOPT="cc"
      else
        _SOPT="$_opt"
      fi
      ;;

    w|v)
      _EOPT="$_EOPT:$_opt:"
      ;;

    *)
      # FIXME: If option is unknown, we will break the loop
      # FIXME: and this option will be used by the native program.
      # FIXME: break 2
      _die "$0: Unknown option '$_opt'."
      ;;
    esac
  done

  shift

  # If the primary option and the secondary are known
  # we would break the argument detection, but for sure we will look
  # forward to see there is anything interesting...
  if [ -n "$_POPT" ] && [ -n "$_SOPT" ]; then
    case "${1:-}" in
    "-w"|"--noconfirm") ;;
    *) break;;
    esac

  # Don't have anything from the **first** argument. Something wrong.
  # FIXME: This means that user must enter at least primary action
  # FIXME: or secondary action in the very first part...
  elif [ -z "${_POPT}${_SOPT}${_TOPT}" ]; then
    break
  fi
done

[ -n "$_POPT" ] \
|| _die "Usage: $0 <options>   # -h for help, -P list supported functions"

_validate_operation "${_PACMAN}_${_POPT}${_SOPT}" \
|| {
  _not_implemented
  exit 1
}

_translate_all || exit

# pacman man page (examples) says:
#   "pacman -Syu gpm = Update package list, upgrade all packages,
#    and then install gpm if it wasn't already installed."
#
# Instead, just disallow specific packages, as (ex-)yum users likely
# expect to just update/upgrade one package (and its dependencies)
# and apt-get and pacman have no way to do this.
#
if [ -n "$*" ]; then
  case "${_POPT}${_SOPT}" in
  "Su"|"Sy"|"Suy")
    if ! echo "$*" | $GREP -Eq -e '(^|\s)-' -e '-+\w+\s+[^-]'; then
      echo 1>&2 "WARNING ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
      echo 1>&2 "  The -Sy/u options refresh and/or upgrade all packages."
      echo 1>&2 "  To install packages as well, use separate commands:"
      echo 1>&2
      echo 1>&2 "    $0 -S$_SOPT; $0 -S ${*:-}"
      echo 1>&2 "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~"
    fi;
  esac
fi

if [ -n "$PACAPT_DEBUG" ]; then
  echo "pacapt: $_PACMAN, p=$_POPT, s=$_SOPT, t=$_TOPT, e=$_EOPT"
  echo "pacapt: execute '${_PACMAN}_${_POPT}${_SOPT} $_EOPT ${*:-}'"
  if command -v declare >/dev/null; then
    # shellcheck disable=SC3044
    declare -f "${_PACMAN}_${_POPT}${_SOPT}"
  else
    _error "Attempted to print the definition of the method '${_PACMAN}_${_POPT}${_SOPT}'."
    _error "However, unable to find method ('declare'). Maybe your shell is purely POSIX?"
  fi
else
  "_${_PACMAN}_init" || exit
  # shellcheck disable=SC2086
  "${_PACMAN}_${_POPT}${_SOPT}" $_EOPT "$@"
fi
