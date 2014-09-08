# Purpose: Gentoo (+ Paludis) / Exherbo support
# Author : Somasis <somasissounds@gmail.com>
# License: Fair license (http://www.opensource.org/licenses/fair)
# Source : http://github.com/somasis/pacapt/

# Copyright (C) 2014 Somasis
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works is
# notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.

# FIXME: This will affect all distributions, because this will be loaded
# FIXME: globally. We need to provide, for example, (cave_init) method.
#
# cave uses asterisks pretty liberally, this is for output parsing correctness
shopt -u globstar

cave_Q() {
  if [[ "$_TOPT" == "q" ]]; then
    # FIXME: Why the `while`? I believe we can skip it, for example:
    # FIXME:  cave show -f "${@:-world}" | grep -v '^$'
    cave show -f "${@:-world}" \
    | while read cave_line; do
        echo $cave_line
      done \
    | grep -v '^$'
  else
    cave show -f "${@:-world}"
  fi
}

cave_Qi() {
  cave show "$@"
}

cave_Ql() {
  if [[ -n "$@" ]]; then
    cave contents "$@"
    return
  fi

  # FIXME: Remove (while) loop, as in (cave_Q)
  cave show -f "${@:-world}" \
  | while read cave_line; do
      echo $cave_line
    done \
  | grep -v '^$' \
  | while read _pkg; do
      if [[ "$_TOPT" == "q" ]]; then
        cave --color no contents "$_pkg"
      else
        cave contents "$_pkg"
      fi
    done
}

cave_Qo() {
  cave owner "$@"
}

cave_Qp() {
  _not_implemented
}

cave_Qu() {
  if [[ -z "$@" ]];then
    cave resolve -c world \
    | grep '^u.*' \
    | while read _pkg; do
        echo "$_pkg" | cut -d'u' -f2-
      done
  else
    cave resolve -c world \
    | grep '^u.*' \
    | grep -- "$@"
  fi
}

cave_Qs() {
  cave show -f world | grep -- "$@"
}

cave_Rs() {
  if [[ "$_TOPT" == "" ]]; then
    cave uninstall -r "$@" \
    && echo "Control-C to stop uninstalling..." \
    && sleep 2s \
    && cave uninstall -xr "$@"
  else
    cave purge "$@" \
    && echo "Control-C to stop uninstalling (+ dependencies)..." \
    && sleep 2s \
    && cave purge -x "$@"
  fi
}

cave_Rn() {
  _not_implemented
}

cave_Rns() {
  _not_implemented
}

cave_R() {
  cave uninstall "$@" \
  && echo "Control-C to stop uninstalling..." \
  && sleep 2s \
  cave uninstall -x "$@"
}

cave_Si() {
  cave show "$@"
}

cave_Suy() {
  cave sync && cave resolve -c "${@:-world}" \
  && echo "Control-C to stop upgrading..." \
  && sleep 2s \
  && cave resolve -cx "${@:-world}"
}

cave_Su() {
  cave resolve -c "$@" \
  && echo "Control-C to stop upgrading..." \
  && sleep 2s \
  && cave resolve -cx "$@"
}

cave_Sy() {
  cave sync "$@"
}

cave_Ss() {
  cave search "$@"
}

cave_Sc() {
  cave fix-cache "$@"
}

cave_Scc() {
  cave fix-cache "$@"
}

cave_Sccc() {
  #rm -fv /var/cache/paludis/*
  _not_implemented
}

cave_S() {
  cave resolve $_TOPT "$@" \
  && echo "Control-C to stop installing..." \
  && sleep 2s \
  && cave resolve -x $_TOPT "$@"
}

cave_U() {
  _not_implemented
}
