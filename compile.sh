#!/bin/bash

# Purpose: A wrapper for all Unix package managers
# Author : Anh K. Huynh
# License: Fair license (http://www.opensource.org/licenses/fair)
# Source : http://github.com/icy/pacapt/

# Copyright (C) 2010 - 2014 Anh K. Huynh et al.
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works is
# notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.

set -u
set -e
unset GREP_OPTIONS

_SUPPORTED_PACMAN="(pkgng|dpkg|homebrew|macports|portage|yum|zypper|cave)"

VERSION="${VERSION:-$(git log --pretty="%h" -1 2>/dev/null)}"
VERSION="${VERSION:-unknown}"

cat <<EOF
#!/usr/bin/env bash
#
# Purpose: A wrapper for all Unix package managers
# License: Fair license (http://www.opensource.org/licenses/fair)
# Source : http://github.com/icy/pacapt/
# Version: $VERSION
# Authors: Anh K. Huynh et al.

# Copyright (C) 2010 - $(date +%Y) | 10sr
#                           | Alexander Dupuy
#                           | Anh K. Huynh
#                           | Arcterus
#                           | Danny George
#                           | Hà-Dương Nguyễn
#                           | Huy Ngô
#                           | James Pearson
#                           | Karol Blazewicz
#                           | Konrad Borowski
#                           | Somasis
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works is
# notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.
#

export PACAPT_VERSION='$VERSION'
EOF

cat <<'EOS'

_help() {
  cat <<'EOF'
EOS

cat ./lib/help.txt

cat <<'EOS'
EOF

}

EOS

for L in ./lib/*.sh; do
  if [[ "${L##*/}" == "zz_main.sh" ]]; then
    echo "_validate_operation() {"
    echo "  case \"\$1\" in"

    grep -hE "^($_SUPPORTED_PACMAN)_[^ \t]+\(\)" ./lib/*.sh \
    | awk -F '(' '{print $1}' \
    | while read F; do
        echo "  \"$F\") ;;"
      done

    echo "  *) return 1 ;;"
    echo "  esac"
    echo "}"
  fi

  cat $L \
  | grep -v '^#' \
  | cat
done

echo 1>&2 "pacapt version '$VERSION' has been generated"
