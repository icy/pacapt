#!/bin/bash

# Purpose: Execute test using data from foobar.txt

# $1: Input file
_test() {
  local _file="${1:-}"
  local _basename="$(basename "$_file" .txt)"
  local _images=

  # See if input is provided with .txt extension
  if [[ "$(basename "$_file")" == "$_basename" ]]; then
    _file="$_file.txt"
  fi

  if [[ ! -f "$_file" ]]; then
    echo >&2 ":: File not found '$_file'. Return(1)."
    return 1
  fi

  echo >&2 ":: Generating 'tmp/$_basename.sh'..."
  ruby -n ../bin/gen_tests.rb < "$_file" > "tmp/$_basename.sh"
  chmod 755 "tmp/$_basename.sh"

  bash -n "tmp/$_basename.sh"
  if [[ $? -ge 1 ]]; then
    return 1
  fi

  if [[ "${TESTS_DO_NOT_RUN:-}" == 1 ]]; then
    return 0
  fi

  _images="$(grep -m1 -E '^im ' "$_file")"
  _count=0
  for _img in $_images; do
    [[ $_img == "im" ]] && continue
    (( _count ++ ))
    echo >&2 ":: Testing $_basename with $_img"
    (
      cd tmp/ || return 1
      docker run --rm \
        -v $PWD/pacapt.dev:/usr/bin/pacman \
        -v "$PWD/$_basename.sh:/tmp/test.sh" \
        $_img \
        /tmp/test.sh 2>"$_basename.${_img//\//-}.log"
    )
    if [[ $? -ge 1 ]]; then
      echo >&2 "FAIL: $_basename/$_img"
      return 1
    fi
  done

  if [[ $_count == 0 ]]; then
    echo >&2 "WARN: $_basename: Forget to specify 'im ' instruction?"
  fi
}

while (( $# )); do
  _test $1 || exit 1
  shift
done
