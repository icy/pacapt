#!/bin/bash

# Purpose: Check script for error
# Author : Anh K. Huynh
# Date   : 2015 Aug 06
# License: MIT license

_simple_check() {
  bash -n "$@"
}

_perl_check() {
  perl -MURI::Escape -e 'exit(0)'
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
    --data "script=$_data" \
  | perl -e '
      use JSON;
      my $stream = do { local $/; <>; };
      my $output = decode_json($stream);
      foreach (keys @{$output}) {
        my $comment = @{$output}[$_];
        printf("%7s %4d: line %4d col %2d, msg %s\n",
          $comment->{"level"}, $comment->{"code"},
          $comment->{"line"}, $comment->{"col"}, $comment->{"message"});
      }
    '
}

_check_file() {
  local _file="${1:-/x/x/x/x/x/x/x/}"

  [[ -f "$_file" ]] \
  || {
    echo >&2 ":: File not found '$_file'"
    return 1
  }

  _simple_check "$_file" || return
  _shellcheck < "$_file"
}

"$@"
