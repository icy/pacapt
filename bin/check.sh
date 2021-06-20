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
  PREFIX="[ ${*} ] " \
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

      printf("%s%s%7s %4d: line %4d col %2d, msg %s%s\n",
        $ENV{"PREFIX"},
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
  local_file="${1:-/x/x/x/x/x/x/x/}"
  local_shell="${SHELLCHECK_SHELL:-bash}"

  echo >&2 ":: ${FUNCNAME[0]} (${local_shell}): $1"

  [[ -f "$local_file" ]] \
  || {
    echo >&2 ":: File not found '$local_file'"
    return 1
  }

  _simple_check "$local_file" || return

  shellcheck -s "${local_shell}" -f json "$local_file" \
  | _shellcheck_output_format "$local_file"

  [[ "${PIPESTATUS[0]}" == "0" ]]
}

_check_POSIX_files() {
  export SHELLCHECK_SHELL="sh"
  while (( $# )); do
    if awk 'NR==1' < "$1" \
      | grep -Eiqe '^#!/usr/bin/env sh' ;
    then
      _check_file "$1" || return 1
    fi
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
