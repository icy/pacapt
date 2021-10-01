#!/usr/bin/env bash

# Purpose : Execute test using data from foobar.txt
# Author  : Ky-Anh Huynh
# License : MIT
# Date    : July 2016 (initial version),
#           June 2021 (parallel support)

__test_an_image_with_docker() {
  local_pacman="${1}"
  local_img="${2}"

  if [ "$local_img" = "im" ]; then
    return 0
  fi

  echo >&2 ":: INFO($local_pacman) Testing with $local_img"
  (
    if [[ -f "Dockerfile.${local_img}" ]]; then
      >&2 echo ":: ... building docker file ${local_img}"
      docker build -t "$local_img" -f "Dockerfile.${local_img}" .
    fi

    cd tmp/ || return 1

    # Bash/shellcheck suggests to avoid `sed`, but we would port
    # this script to POSIX (which is impossible for now due to
    # the use of `export -f` as seen in the next part of the script).

    MSG_PREFIX="( $local_pacman vs. $local_img )"
    # shellcheck disable=SC2001
    docker run --rm \
      -v "$PWD/pacapt.dev:/usr/bin/pacman" \
      -v "$PWD/$local_pacman.sh:/tmp/test.sh" \
      -e "MSG_PREFIX=:: INFO $MSG_PREFIX " \
      "$local_img" \
      /tmp/test.sh 2>"$local_pacman.$(echo "$local_img" | sed -e "s!/!-!g").log"
  )
  if [ $? -ge 1 ]; then
    echo >&2 ":: FAIL $MSG_PREFIX"
    return 1
  fi
}

# $1: Input file
_test() {
  local_file="${1:-}"
  local_pacman="$(basename "$local_file" .txt)"
  local_images=

  # See if input is provided with .txt extension
  if [ "$(basename "$local_file")" = "$local_pacman" ]; then
    local_file="$local_file.txt"
  fi

  if [ ! -f "$local_file" ]; then
    echo >&2 ":: ERRO($local_pacman): File not found '$local_file'. Return(1)."
    return 1
  fi

  echo >&2 ":: INFO($local_pacman) Generating 'tmp/$local_pacman.sh'..."
  sh ../bin/gen_tests.sh < "$local_file" > "tmp/$local_pacman.sh"
  chmod 755 "tmp/$local_pacman.sh"

  if ! sh -n "tmp/$local_pacman.sh"; then
    return 1
  fi

  if [ "${TESTS_DO_NOT_RUN:-}" = 1 ]; then
    return 0
  fi

  if [ -z "$IMAGES" ]; then
    local_images="$(grep -E '^im ' "$local_file" | sed -re 's/^ *im +//g')"
  else
    >&2 echo ":: INFO($local_pacman) Using image(s) from IMAGES (${IMAGES})"
    local_images="${IMAGES}"
  fi

  for img in $local_images; do
    local_pacmans="$local_pacmans $local_pacman"
  done

  # export -f is requiring `Bash` =))
  local_plog="tmp/parallel.$local_pacman.log"
  export -f __test_an_image_with_docker
  # shellcheck disable=SC2086
  parallel \
    --link \
    --line-buffer \
    --joblog "$local_plog" \
    __test_an_image_with_docker \
    ::: $local_pacmans \
    ::: $local_images

  cat "$local_plog"

  tail -n+2 "$local_plog" \
  | awk '
      BEGIN {
        n_tests = 0
        exit_code = 0
      }
      /[0-9]/ {
        n_tests += 1 ;
        if ($7 > 0) {
          exit_code = 1;
        }
      }
      END {
        exit(exit_code)
      }
    '

  if [ $? -eq 0 ]; then
    echo ":: INFO: All test(s) passed."
  else
    echo ":: ERRO: Some test(s) failed."
    return 1
  fi
}

while [ $# -gt 0 ]; do
  _test "$1" || exit 1
  shift
done
