#!/usr/bin/env sh

# Purpose : pacman-style wrapper for cygwin/apt-cyg tool
# Authors : Ky-Anh Huynh (icy)
# Date    : 2021-10-04
# License : Public domain

_apt_cyg_init() {
  :
}

apt_cyg_Ss() {
  apt-cyg search "$@"
}

apt_cyg_S() {
  apt-cyg install "$@"
}

apt_cyg_Sy() {
  apt-cyg update "$@"
}

apt_cyg_Q() {
  apt-cyg list "$@"
}

apt_cyg_Qi() {
  apt-cyg show "$@"
}

apt_cyg_Ql() {
  for pkg in "$@"; do
    if [ "$_TOPT" = "q" ]; then
      apt-cyg listfiles "$pkg"
    else
       apt-cyg listfiles "$pkg" \
       | pkg="$pkg" \
         awk '{printf("%s %s\n", ENVIRON["pkg"], $0)}'
    fi
  done
}

apt_cyg_R() {
  apt-cyg remove "$@"
}
