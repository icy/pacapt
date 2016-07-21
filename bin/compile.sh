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

: "${PACAPT_STATS=}"  # List implemented operations to STDERR
: "${GREP:=grep}"     # Need to update on SunOS
: "${AWK:=awk}"       # Need to update on SunOS

# At compile time, `_sun_tools_init` is not yet defined.
if [[ -f "lib/sun_tools.sh" ]]; then
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
  bash -n "$L" || return 1
  [[ "${L##*/}" != "zz_main.sh" ]] \
  || continue

  $GREP -v '^#' "$L"
done

########################################################################
# Create the `_validate_operation` method.
# Detect all supported operations.
########################################################################

_operations=()

echo "_validate_operation() {"
echo "  case \"\$1\" in"

for L in ./lib/*.sh; do
  _PKGNAME="${L##*/}"
  _PKGNAME="${_PKGNAME%.*}"

  case "$_PKGNAME" in
  "zz_main"|"00_core") continue ;;
  esac

  while read F; do
    echo "  \"$F\") ;;"
    _operations+=( "$F" )
  done < \
    <(
      $GREP -hE "^${_PKGNAME}_[^ \t]+\(\)" "$L" \
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

########################################################################
# Stop here, or continue...
########################################################################

if [[ -z "${PACAPT_STATS:-}" ]]; then
  echo >&2 "pacapt version '$VERSION' has been generated"
  exit
fi

########################################################################
# For developers only
#
#  PxO  Q Qi Qs ...
# dpkg  x  o  o ...
# yum   o  o  o ...
#
########################################################################

_soperations="$(
  echo "${_operations[@]}" \
  | sed -e 's# #\n#g' \
  | sed -e 's#^.*_\([A-Z][a-z]*\)#\1#g' \
  | sort -u
  )"

# Print the headers
_ret="$(printf "| %9s " "")"
for _sopt in $_soperations; do
  _size="$(( ${#_sopt} + 1))"
  _ret="$(printf "%s%${_size}s" "$_ret" "$_sopt")"
done
printf >&2 "%s\n" "$_ret"

i=0   # index
rs=0  # restart

_operations+=( "xxx_yyy" )

while :; do
  _ret=""

  [[ "$i" -lt "${#_operations[@]}" ]] \
  || break

  _cur_pkg="${_operations[$i]}"
  _cur_pkg="${_cur_pkg%_*}"

  for _sopt in $_soperations; do
    # Detect flag for this secondary option
    _flag="."

    # Start from the #rs index,
    # go to boundary of the next package name.
    #     xx_Qi, xx_Qs,...  yy_Qi, yy_Qs,...
    #
    i=$rs
    while [[ "$i" -lt "${#_operations[@]}" ]]; do
      _opt="${_operations[$i]}"

      _cur2_opt="${_opt##*_}"
      _cur2_pkg="${_opt%_*}"

      # echo >&2 "(cur_pkg = $_cur_pkg, look up $_sopt [from $rs], found $_cur2_opt)"

      # Reach the boundary of the next package name
      if [[ "$_cur2_pkg" != "$_cur_pkg" ]]; then
        break
      else
        if [[ "$_cur2_opt" == "$_sopt" ]]; then
          _flag="y"
          break
        else
          (( i ++ )) ||:
        fi
      fi
    done

    _size="$(( ${#_sopt} + 1))"
    _ret="$(printf "%s%${_size}s" "$_ret" "$_flag")"
  done

  # Detect the next #restart index
  i=$rs
  while [[ "$i" -lt "${#_operations[@]}" ]]; do
    _opt="${_operations[$i]}"
    _cur2_pkg="${_opt%_*}"

    if [[ "$_cur2_pkg" != "$_cur_pkg" ]]; then
      rs=$i
      break
    fi

    (( i ++ )) ||:
  done

  if [[ "$_cur_pkg" != "xxx" ]]; then
    printf >&2 "| %9s %s\n" "$_cur_pkg" "$_ret"
  fi
done

########################################################################
# Print statistics and the fancy table
########################################################################

echo >&2 "pacapt version '$VERSION' has been generated"
