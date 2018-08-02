#!/usr/bin/env bash

# Purpose : Ruby gems support
# Author  : Ky-Anh Huynh
# License : MIT

_gem_init() {
  :
}

gem_Qq() {
  gem list --local | awk '{print $1}'
}

gem_Q() {
  gem list --local
}
