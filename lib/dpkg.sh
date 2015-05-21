# Purpose: Debian / Ubuntu support
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

_dpkg_init() {
  :
}

dpkg_noconfirm() {
  [[ "$_NO_CONFIRM" == "yes" ]] && _TOPT="$_TOPT --assume-yes"
}

dpkg_Q() {
  if [[ "$_TOPT" == "q" ]]; then
    dpkg -l \
    | grep -E '^[hi]i' \
    | awk '{print $2}'
  elif [[ "$_TOPT" == "" ]]; then
    dpkg -l "$@" \
    | grep -E '^[hi]i'
  else
    _not_implemented
  fi
}

dpkg_Qi() {
  dpkg-query -s "$@"
}

dpkg_Ql() {
  if [[ -n "$@" ]]; then
    dpkg-query -L "$@"
    return
  fi

  dpkg -l \
  | grep -E '^[hi]i' \
  | awk '{print $2}' \
  | while read _pkg; do
      if [[ "$_TOPT" == "q" ]]; then
        dpkg-query -L "$_pkg"
      else
        dpkg-query -L "$_pkg" \
        | while read _line; do
            echo "$_pkg $_line"
          done
      fi
    done
}

dpkg_Qo() {
  dpkg-query -S "$@"
}

dpkg_Qp() {
  dpkg-deb -I "$@"
}

dpkg_Qu() {
  apt-get upgrade --trivial-only "$@"
}

dpkg_Qs() {
  dpkg-query -W "*$@*" | cut -f1
}

dpkg_Rs() {
  if [[ "$_TOPT" == "" ]]; then
    apt-get autoremove "$@"
  else
    _not_implemented
  fi
}

dpkg_Rn() {
  dpkg_noconfirm
  apt-get purge $_TOPT "$@"
}

dpkg_Rns() {
  dpkg_noconfirm
  apt-get --purge autoremove $_TOPT "$@"
}

dpkg_R() {
  dpkg_noconfirm
  apt-get remove $_TOPT "$@"
}

dpkg_Si() {
  apt-cache show "$@"
}

dpkg_Suy() {
  dpkg_noconfirm
  apt-get update \
  && apt-get upgrade $_TOPT "$@"
}

dpkg_Su() {
  dpkg_noconfirm
  apt-get upgrade $_TOPT "$@"
}

# FIXME: Should we remove "$@"?
dpkg_Sy() {
  dpkg_noconfirm
  apt-get update $_TOPT "$@"
}

dpkg_Ss() {
  apt-cache search "$@"
}

dpkg_Sc() {

  apt-get clean "$@"
}

dpkg_Scc() {
  apt-get autoclean "$@"
}

dpkg_Sccc() {
  rm -fv /var/cache/apt/*.bin
  rm -fv /var/cache/apt/archives/*.*
  rm -fv /var/lib/apt/lists/*.*
  apt-get autoclean
}

dpkg_S() {
  dpkg_noconfirm
  apt-get install $_TOPT "$@"
}

dpkg_U() {
  dpkg -i "$@"
}
