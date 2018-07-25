#!/usr/bin/env bash

# Purpose : Generate the table of implemented operations
# Author  : Ky-Anh Huynh
# License : MIT
# Origin  : ./bin/compile.sh

# <DRY_ME_PLEASE>
: "${PACAPT_STATS:=yes}"  # List implemented operations to STDERR
: "${GREP:=grep}"         # Need to update on SunOS
: "${AWK:=awk}"           # Need to update on SunOS
: "${SYM_PARTIALLY_SUPPORTED:=~}"
: "${SYM_FULLY_SUPPORTED:=*}"
: "${SYM_NOT_SUPPORTED:=x}"
: "${SYM_UNKNOWN:= }"

# At compile time, `_sun_tools_init` is not yet defined.
if [[ -f "lib/sun_tools.sh" ]]; then
  # shellcheck disable=1091
  source "lib/sun_tools.sh" :
  _sun_tools_init
fi

export GREP AWK VERSION PACAPT_STATS
# </DRY_ME_PLEASE>

# $1:
_implState() {
  if grep -qs "# ${1} _not_implemented" ./lib/*.sh; then
    echo "${SYM_NOT_SUPPORTED}"
  elif grep -qs "# ${1} may _not_implemented" ./lib/*.sh; then
    echo "${SYM_PARTIALLY_SUPPORTED}"
  else
    echo "${SYM_FULLY_SUPPORTED}"
  fi
}

printf >&2 ":: %s: Generating statistics (table of implemented operations)..." "$0"

# Operations (FQDN)
_OPERATIONS=()
for L in ./lib/*.sh; do
  _PKGNAME="${L##*/}"
  _PKGNAME="${_PKGNAME%.*}"

  case "$_PKGNAME" in
  "zz_main"|"00_core") continue ;;
  esac

  while read -r F; do
    _OPERATIONS+=( "$F" )
  done < \
    <(
      # shellcheck disable=2016
      $GREP -hE "^${_PKGNAME}_[^ \\t]+\\(\\)" "$L" \
       | $AWK -F '(' '{print $1}'
    )
done

# Secondary options
_SOPERATIONS="$(
  echo "${_OPERATIONS[@]}" \
  | sed -e 's# #\n#g' \
  | sed -e 's#^.*_\([A-Z][a-z]*\)#\1#g' \
  | sort -u
  )"

printf "\\n"
printf "\`\`\`\\n"

# Print the headers
_ret="$(printf "%9s " "")"
for _sopt in $_SOPERATIONS; do
  _size="$(( ${#_sopt} + 1))"
  _ret="$(printf "%s%${_size}s" "$_ret" "$_sopt")"
done
printf "%s\\n" "$_ret"

i=0   # index
rs=0  # restart

_OPERATIONS+=( "xxx_yyy" )

while :; do
  _ret=""

  [[ "$i" -lt "${#_OPERATIONS[@]}" ]] \
  || break

  _cur_pkg="${_OPERATIONS[$i]}"
  _cur_pkg="${_cur_pkg%_*}"

  for _sopt in $_SOPERATIONS; do
    # Detect flag for this secondary option
    _flag="${SYM_UNKNOWN}"

    # Start from the #rs index,
    # go to boundary of the next package name.
    #     xx_Qi, xx_Qs,...  yy_Qi, yy_Qs,...
    #
    i=$rs
    while [[ "$i" -lt "${#_OPERATIONS[@]}" ]]; do
      _opt="${_OPERATIONS[$i]}"

      _cur2_opt="${_opt##*_}"
      _cur2_pkg="${_opt%_*}"

      # echo >&2 "(cur_pkg = $_cur_pkg, look up $_sopt [from $rs], found $_cur2_opt)"

      # Reach the boundary of the next package name
      if [[ "$_cur2_pkg" != "$_cur_pkg" ]]; then
        break
      else
        if [[ "$_cur2_opt" == "$_sopt" ]]; then
          # detect real state of this operation...
          _flag="$(_implState "$_opt")"
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
  while [[ "$i" -lt "${#_OPERATIONS[@]}" ]]; do
    _opt="${_OPERATIONS[$i]}"
    _cur2_pkg="${_opt%_*}"

    if [[ "$_cur2_pkg" != "$_cur_pkg" ]]; then
      rs=$i
      break
    fi

    (( i ++ )) ||:
  done

  if [[ "$_cur_pkg" != "xxx" ]]; then
    printf "%9s %s\\n" "$_cur_pkg" "$_ret"
  fi
done

printf "\`\`\`\\n"
printf "\\n**Notes:**\\n\\n"
printf "* \`%s\`: Implemented;\\n" "${SYM_FULLY_SUPPORTED}"
printf "* \`%s\`: Implemented. Some options may not supported/implemented;\\n" "${SYM_PARTIALLY_SUPPORTED}"
printf "* \`%s\`: Operation is not supported by Operating system;\\n" "${SYM_NOT_SUPPORTED}"
printf "* The table is generated from source. Please don't update it manually.\\n"
printf "\\n"
