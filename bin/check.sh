#!/usr/bin/env bash

# Purpose: Check script for error
# Author : Anh K. Huynh
# Date   : 2015 Aug 06
# License: MIT license

_simple_check() {
  bash -n "$@"
}

_perl_check() {
  perl -MURI::Escape -MJSON -e 'exit(0)'
}

_shellcheck() {
  local _data

  _data="$( \
    perl -MURI::Escape \
      -e '
        my $stream = do { local $/; <STDIN>; };
        print uri_escape($stream);
      '
    )"

  curl -LsSo- \
    'http://www.shellcheck.net/shellcheck.php' \
    -H 'Accept: application/json, text/javascript, */*' \
    -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' \
    -H 'Host: www.shellcheck.net' \
    -H 'Referer: http://www.shellcheck.net/' \
    -H 'User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:39.0) Gecko/20100101 Firefox/39.0' \
    -H 'X-Requested-With: XMLHttpRequest' \
    --data "script=$_data"
}

_shellcheck_output_format() {
  perl -e '
    use JSON;
    my $stream = do { local $/; <>; };
    my $output = decode_json($stream);
    my $colors = {
        "error" => "\e[1;31m",
        "warning" => "\e[1;33m",
        "style" => "\e[1;36m",
        "default" => "\e[0m",
        "reset" => "\e[0m"
        };

    foreach (keys @{$output}) {
      my $comment = @{$output}[$_];
      my $color = $colors->{$comment->{"level"}} || $colors->{"default"};

      printf("%s%7s %4d: line %4d col %2d, msg %s%s\n",
        $color,
        $comment->{"level"}, $comment->{"code"},
        $comment->{"line"}, $comment->{"column"},
        $comment->{"message"},
        $colors->{"reset"}
        );
    }
  '
}

# See discussion in https://github.com/icy/pacapt/pull/59
_has_shellcheck() {
  command -v shellcheck >/dev/null 2>&1
}

_check_file() {
  local _file="${1:-/x/x/x/x/x/x/x/}"

  echo >&2 ":: ${FUNCNAME[0]}: $1"

  [[ -f "$_file" ]] \
  || {
    echo >&2 ":: File not found '$_file'"
    return 1
  }

  _simple_check "$_file" || return

  if _has_shellcheck; then
    shellcheck -f json "$_file" | _shellcheck_output_format
  else
    _shellcheck < "$_file" | _shellcheck_output_format
  fi
}

_check_files() {
  _has_shellcheck \
  || {
    echo >&2 ":: WARN: shellcheck not found."
    echo >&2 ":: WARN: Scripts will be checked by remote web server."
  }
  while (( $# )); do
    _check_file "$1" || return 1
    shift
  done
}

_perl_check || exit 1

"$@"
