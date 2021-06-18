#!/usr/bin/env bash

# Purpose: Check script for error
# Author : Anh K. Huynh
# Date   : 2015 Aug 06
# License: MIT license

_simple_check() {
  bash -n "$@"
}

_has_perl_json() {
  perl -MURI::Escape -MJSON -e 'exit(0)'
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
  : "${SHELLCHECK_TAG:=v0.7.2}"
  if [[ -n "${CI_SHELLCHECK_UPDATE:-}" && "$OSTYPE" =~ linux.* ]]; then
    echo >&2 ":: Downloading shellcheck to $(pwd -P)..."
    wget --quiet -O shellcheck.tar.xz -c "https://github.com/koalaman/shellcheck/releases/download/${SHELLCHECK_TAG}/shellcheck-${SHELLCHECK_TAG}.linux.x86_64.tar.xz"
    tar xJf shellcheck.tar.xz
    PATH="$(pwd -P)"/shellcheck-${SHELLCHECK_TAG}/:$PATH
    export PATH
  fi

  if ! command -v shellcheck >/dev/null 2>&1; then
    >&2 echo ":: Sorry, shellcheck is required."
    return 1
  fi
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

  shellcheck -s "${SHELLCHECK_SHELL:-bash}" -f json "$_file" | _shellcheck_output_format
  [[ "${PIPESTATUS[0]}" == "0" ]]
}

_check_POSIX_file() {
  if ! grep -Eiqe "^# +POSIX.*:.*Ready" -- "$1" ; then
    >&2 echo ":: $1: POSIX is not required."
  else
    _check_file "$1" || return 1
  fi
}

_check_POSIX_files() {
  export SHELLCHECK_SHELL="sh"
  while (( $# )); do
    _check_POSIX_file "$1" || return 1
    shift
  done
}

_check_files() {
  while (( $# )); do
    # FIXME: For now, we always return 0!!!
    _check_file "$1"
    shift
  done
}

_has_perl_json && _has_shellcheck || exit 1
shellcheck --version

"$@"
