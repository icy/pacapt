#!/usr/bin/env bash

# Purpose: `Compile` libraries from `lib/*`  to create `pacapt` script.
# Author : Anh K. Huynh
# License: Fair license (http://www.opensource.org/licenses/fair)
# Source : http://github.com/icy/pacapt/

# Copyright (C) 2010 - 2015 Anh K. Huynh et al.
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works is
# notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.

set -u
set -e
unset GREP_OPTIONS

VERSION="${VERSION:-$(git log --pretty="%h" -1 2>/dev/null || true)}"
VERSION="${VERSION:-unknown}"

if [[ "${VERSION}" == "unknown" ]]; then
  echo >&2 ":: Unable to get version information."
  echo >&2 ":: You may to install or reconfigure your 'git' package."
  exit 1
fi

: "${PACAPT_STATS:=yes}"  # List implemented operations to STDERR
: "${GREP:=grep}"     # Need to update on SunOS
: "${AWK:=awk}"       # Need to update on SunOS

# At compile time, `_sun_tools_init` is not yet defined.
if [[ -f "lib/sun_tools.sh" ]]; then
  # shellcheck disable=1091
  source "lib/sun_tools.sh" :
  _sun_tools_init
fi

export GREP AWK VERSION PACAPT_STATS

########################################################################
# Print the shebang and header
########################################################################

cat <<EOF
#!/usr/bin/env bash
#
# Purpose: A wrapper for all Unix package managers
# License: Fair license (http://www.opensource.org/licenses/fair)
# Source : http://github.com/icy/pacapt/
# Version: $VERSION
# Authors: Anh K. Huynh et al.

# Copyright (C) 2010 - $(date +%Y) \\
$( \
  < README.md \
  sed -e '1,/AUTHORS/d' \
  | $GREP '*' \
  | sed -e 's,*,#                           |,g')
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works is
# notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.
#

_print_pacapt_version() {
  cat <<_EOF_
pacapt version '$VERSION'

Copyright (C) 2010 - $(date +%Y) \\\\
$( \
  < README.md \
  sed -e '1,/AUTHORS/d' \
  | $GREP '*' \
  | sed -e 's,*,                          |,g')

Usage of the works is permitted provided that this
instrument is retained with the works, so that any
entity that uses the works is notified of this instrument.

DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.
_EOF_
}

export PACAPT_VERSION='$VERSION'
EOF

########################################################################
# Create help method
########################################################################

cat <<'EOS'

_help() {
  cat <<'EOF'
EOS

# The body of help message
cat ./lib/help.txt

cat <<'EOS'
EOF

}

EOS

########################################################################
# Print the source of all library files, except (zz_main.sh)
########################################################################

for L in ./lib/*.sh; do
  bash -n "$L" || exit 1
  [[ "${L##*/}" != "zz_main.sh" ]] \
  || continue

  $GREP -v '^#' "$L"
done

########################################################################
# Create the `_validate_operation` method.
# Detect all supported operations.
########################################################################

echo "_validate_operation() {"
echo "  case \"\$1\" in"

for L in ./lib/*.sh; do
  _PKGNAME="${L##*/}"
  _PKGNAME="${_PKGNAME%.*}"

  case "$_PKGNAME" in
  "zz_main"|"00_*") continue ;;
  esac

  while read -r F; do
    echo "  \"$F\") ;;"
  done < \
    <(
      # shellcheck disable=2016
      $GREP -hE "^${_PKGNAME}_[^ \\t]+\\(\\)" "$L" \
       | $AWK -F '(' '{print $1}'
    )
done

echo "  *) return 1 ;;"
echo "  esac"
echo "}"

########################################################################
# Print the source of `zz_main.sh`.
# `zz_main` doesn't contain only Bash function.
# It should be included in the last part of the script.
########################################################################

$GREP -v '^#' lib/zz_main.sh

echo >&2 "pacapt version '$VERSION' has been generated."
