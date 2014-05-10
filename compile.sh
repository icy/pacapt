#!/bin/bash

# Purpose: A wrapper for all Unix package managers
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

set -u
set -e
unset GREP_OPTIONS

_SUPPORTED_PACMAN="(pkgng|dpkg|homebew|macports|portage|yum|zypper)"

VERSION="${VERSION:-$(git log --pretty="%h" -1 2>/dev/null)}"
VERSION="${VERSION:-unknown}"

cat <<EOF
#!/usr/bin/env bash
#
# Purpose: A wrapper for all Unix package managers
# Author : Anh K. Huynh
# License: Fair license (http://www.opensource.org/licenses/fair)
# Source : http://github.com/icy/pacapt/
# Version: $VERSION

# Copyright (C) 2010 - $(date +%Y) Anh K. Huynh
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works is
# notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.
#

export PACAPT_VERSION='$VERSION'
EOF

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
