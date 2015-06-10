# Purpose: RedHat / Fedora Core support
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

_yum_init() {
  [[ "$_NOCONFIRM_FLAG" == "yes" ]] && _TOPT="$_TOPT --assumeyes"
}

yum_Q() {
  if [[ "$_TOPT" == "q" ]]; then
    rpm -qa --qf "%{NAME}\n"
  elif [[ "$_TOPT" == "" ]]; then
    rpm -qa --qf "%{NAME} %{VERSION}\n"
  else
    _not_implemented
  fi
}

yum_Qi() {
  yum info "$@"
}

yum_Ql() {
  rpm -ql "$@"
}

yum_Qo() {
  rpm -qf "$@"
}

yum_Qp() {
  rpm -qp "$@"
}

yum_Qc() {
  rpm -q --changelog "$@"
}

yum_Qu() {
  yum list updates "$@"
}

yum_Qm() {
  yum list extras "$@"
}

yum_Rs() {
  if [[ "$_TOPT" == " --assumeyes" ]] || [[ "$_TOPT" == "" ]]; then
    yum erase $_TOPT "$@"
  else
    _not_implemented
  fi
}

yum_R() {
  yum erase $_TOPT "$@"
}

yum_Si() {
  yum info "$@"
}

yum_Suy() {
  yum update $_TOPT "$@"
}

yum_Su() {
  yum update $_TOPT "$@"
}

yum_Sy() {
  yum check-update "$@"
}

yum_Ss() {
  yum -C search "$@"
}

yum_Sc() {
  yum clean expire-cache "$@"
}

yum_Scc() {
  yum clean packages "$@"
}

yum_Sccc() {
  yum clean all "$@"
}

yum_S() {
  yum install $_TOPT "$@"
}

yum_U() {
  yum localinstall "$@"
}

yum_Sii() {
  yum resolvedep "$@"
}
