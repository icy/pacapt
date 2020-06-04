#!/usr/bin/env bash

# Purpose : conda support
# Author  : Antony Lee
# License : MIT
# Date    : September 4, 2018

# Copyright (C) 2018 Antony Lee
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works is
# notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.

_conda_init() {
  :
}

conda_Q() {
  if [[ $# -gt 0 ]]; then
    conda list "$(python -c 'import sys; print("^" + "|".join(sys.argv[1:]) + "$")' "$@")"
  else
    conda list
  fi
}

conda_R() {
  conda remove "$@"
}

conda_S() {
  conda install "$@"
}

conda_Sc() {
  conda clean --all "$@"
}

conda_Si() {
  conda search "$@" --info
}

conda_Ss() {
  conda search "*$@*"
}

conda_Suy() {
  conda update --all "$@"
}

