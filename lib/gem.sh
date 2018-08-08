#!/usr/bin/env bash

# Purpose : Ruby gems support
# Author  : Ky-Anh Huynh
# License : MIT

_gem_init() {
  :
}

gem_Qq() {
  gem list --local "$@" | awk '{print $1}'
}

gem_Q() {
  gem list --local "$@"
}

# $ gem list -d rack
#
# *** LOCAL GEMS ***
#
# descendants_tracker (0.0.4)
#     Authors: Dan Kubb, Piotr Solnica, Markus Schirp
#     Homepage: https://github.com/dkubb/descendants_tracker
#     License: MIT
#     Installed at: /usr/lib/ruby/gems/2.5.0
#
#     Module that adds descendant tracking to a class
#
# rack (2.0.5, 2.0.3)
#     Author: Leah Neukirchen
#     Homepage: https://rack.github.io/
#     License: MIT
#     Installed at (2.0.5): /usr/lib/ruby/gems/2.5.0
#                  (2.0.3): /usr/lib/ruby/gems/2.5.0
#
#     a modular Ruby webserver interface
#
# rack-protection (2.0.3, 2.0.0)
#     Author: https://github.com/sinatra/sinatra/graphs/contributors
#     Homepage: http://www.sinatrarb.com/protection/
#     License: MIT
#     Installed at (2.0.3): /usr/lib/ruby/gems/2.5.0
#                  (2.0.0): /usr/lib/ruby/gems/2.5.0
#
#     Protect against typical web attacks, works with all Rack apps,
#     including Rails.
gem_Ql() {
  gem list -d "$@" \
  | grep -E -e '(^[^[:space:]]+ \()|(Installed at)' \
  | paste - - \
  | awk -F '[() ]' '{printf("%s %s/gems/%s-%s\n", $1, $NF, $1, $3)}' \
  | while read -r _pkg _dir; do
      find "$_dir/" -type f \
      | awk -v PKG="$_pkg" '{printf("%s %s\n", PKG, $0)}'
    done
}

gem_S() {
  gem install "$@"
}

gem_U() {
  gem install "$@"
}

gem_Ss() {
  gem list --both "$@"
}

gem_Qi() {
  gem list -d "$@"
}

gem_R() {
  gem uninstall "$@"
}
