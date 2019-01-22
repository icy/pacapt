#!/usr/bin/env bash

# Author  : Ky-Anh Huynh
# License : MIT

set -uex

if [[ "${TRAVIS_BRANCH:-}" != "nd" ]]; then
  echo >& ":: Skip deployment as current branch '${TRAVIS_BRANCH:-} is not 'nd'."
fi

# if command -v apt-get >/dev/null; then
#   sudo apt-get install ruby
#   sudo -H gem install bundler
# fi

D_ROOT="$(dirname "${BASH_SOURCE[0]:-.}")/../"
D_ROOT="$(cd "${D_ROOT}" && pwd -P)"

BIN_TAG="v1.0.0"
wget -c https://github.com/icy/bin/archive/${BIN_TAG}.tar.gz
tar xfvz ${BIN_TAG}.tar.gz

cd bin-${BIN_TAG#v*} || exit
pwd
rm -fv Gemfile.lock
bundle install

FILE_NAME="pacapt-${TRAVIS_BRANCH:-nd}-linux-amd64.tar.gz"
tar cfvz "$FILE_NAME" "$D_ROOT/output/pacapt"
sha256sum "$FILE_NAME" > "$FILE_NAME.sha256"

bundle exec -- foo.rb \
  --user icy --repo bin \
  --release "pacapt-devel" \
  --overwrite \
  --name "$FILE_NAME" \
  --file "$FILE_NAME"

bundle exec -- foo.rb \
  --user icy --repo bin \
  --release "pacapt-devel" \
  --overwrite \
  --name "$FILE_NAME.sha256" \
  --file "$FILE_NAME.sha256"
