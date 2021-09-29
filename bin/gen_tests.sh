#!/usr/bin/env sh

# Purpose: Generate test scripts
# Author : Álvaro Mondéjar Rubio
# License: MIT
# Date   : 2021 September 29th
# Example:
#
#   $ sh ./bin/gen_tests.sh < lib/dpkg.txt > ./test.sh
#   $ docker run --rm \
#       -v $PWD/test.sh:/tmp/test.sh \
#       -v $PWD/pacapt.dev:/usr/bin/pacman \
#       -e "MSG_PREFIX=:: (INFO) " \
#       ubuntu:14.04 \
#       /bin/sh /tmp/test.sh 2>test.log

echo "#!/bin/sh"
echo ""
echo "# Notes: This file is generated. Please don't modify them manually."
echo ""
echo "export PATH=/sbin:/bin:/usr/sbin:/usr/bin:\$PATH"
echo ""
echo "N_TEST=0  # Total number of tests"
echo "N_FAIL=0  # Number of failed tests"
echo "F_TMP=    # Temporary file"
echo "T_FAIL=0  # Number of failed tests in current block"
echo ""
echo "set -u"
echo ""
echo ": \"\${GGREP:=grep}\""
echo ""
echo "if [ \"\$(uname)\" = \"SunOS\" ]; then"
echo "  GGREP=ggrep"
echo "fi"
echo ""
#
# Just send message to STDERR
#
# When CI is set, we expect the current test script is executed directly
# by Github-Runner shell (not via our Docker launcher.)
# This is the case for non-docker tests (homebrew, pkgng).
# We need to reduce the duplicate log message in these cases.
#
echo "_log()  { if [ -z \"\${CI:-}\" ]; then echo \"\$*\" 1>&2 ; fi; }"

# A fancy wrappers of _log
#
# Where there is any message, we need to ensure they are on both
# channels (STDIN, STDERR). Normally, the STDERR has more verbose
# information, i.e, the output of all executions. The STDERR will
# be [often] captured for later investigation and it's done via
# the `tests/test.sh`. From STDIN we try to keep it compact.
# ...
#
# shellcheck disable=SC2028
echo "_fail() { _log \"\${MSG_PREFIX}Fail: \$*\"; printf \"\${MSG_PREFIX}\e[31mFail\e[0m: %s\n\" \"\$*\"; }" # red
echo "_erro() { _log \"\${MSG_PREFIX}Erro: \$*\"; echo \"\${MSG_PREFIX}Erro: \$*\"; }" # red
echo "_info() { _log \"\${MSG_PREFIX}Info: \$*\"; echo \"\${MSG_PREFIX}Info: \$*\"; }" # cyan
echo "_pass() { _log \"\${MSG_PREFIX}Pass: \$*\"; echo \"\${MSG_PREFIX}Pass: \$*\"; }" # cyan
echo "_exec() { _log \"\${MSG_PREFIX}Exec: \$*\"; echo \"\${MSG_PREFIX}Exec: \$*\"; }" # yellow
echo "_warn() { _log \"\${MSG_PREFIX}Warn: \$*\"; echo \"\${MSG_PREFIX}Warn: \$*\"; }" # yellow
echo "_stde() { _log \"\${MSG_PREFIX}Info: \$*\"; }"

# Create a secure log (file) stream. If the file was set in \$F_TMP
# we print out all output and remove that too.
echo "_slog() {"
echo "  if [ -n \"\${F_TMP:-}\" ]; then"
# ... first we record all logs to STDERR for later investigation
echo "    if [ -z \"\${CI:-}\" ]; then"
echo "      _stde 'Exec. output:'"
echo "      1>&2 cat \$F_TMP"
echo "    fi"
# ...
# but when our test fails, we also print the first 100 lines to
# the STDOUT, so that we can see them quickly. It can be tricky
# when  homebrew/pkgng fails, because we don't have any access
# to MacOS environment on github-action runner. But let's see...
echo "    if [ \$T_FAIL -ge 1 ]; then"
echo "      cat \$F_TMP \\"
# shellcheck disable=SC2028
echo "      | awk '{ if (NR <= 100) { printf(\" > %s\\\n\", \$0); }}"
# shellcheck disable=SC2028
echo "         END { if (NR > 100) { printf(\" > ...\\\n\");}}'"
echo "    fi"
echo "    rm -f \"\${F_TMP}\""
# We record a seperator in the output because it's too verbose
echo "    _stde ====================================================="
echo "    export T_FAIL=0"
echo "  else"
echo "    export T_FAIL=0"
echo "    export F_TMP=\"\$(mktemp)\""
echo "    if [ -z \"\${F_TMP:-}\" ]; then"
echo "      _fail 'Unable to create temporary file.'"
echo "    fi"
echo "  fi"
echo "}"

new_test=1

while read -r line; do
  first_3_chars="$(echo "$line" | cut -c -1,2,3)"
  if [ "$first_3_chars" = "in " ]; then
    if [ "$new_test" -eq 1 ]; then
        echo ""
        echo "_slog"
        new_test=0
    fi

    cmd="$(
      echo "$line" \
      | cut -c 4- \
      | PATTERN=\$LOG REPL=\$F_TMP awk '{gsub(ENVIRON["PATTERN"], ENVIRON["REPL"]); print}'
    )"

    if [ "$cmd" = "clear" ]; then
      cmd="echo > \$F_TMP"
    elif [ "$(echo "$cmd" | cut -c 1-2)" = "! " ]; then
      # stripped command without !
      cmd="$(echo "$cmd" | cut -c 3-)"
    else
      cmd="pacman $cmd"
    fi

    # FIXME: We wanted to use `tee` here, but that will create new pipes,
    # FIXME: and hence some feature didn't work (e.g., export FOO=).
    echo "if [ -n \"\${F_TMP:-}\" ]; then"
    echo "  _exec \"$cmd\""
    echo "  { $cmd ; } 1>>\$F_TMP 2>&1"
    echo "fi"
  elif [ "$first_3_chars" = "ou " ]; then
    new_test=1
    expected="$(echo "$line" | cut -c 4-)"

    echo "N_TEST=\$(( N_TEST + 1 ))"
    echo "if [ -n \"\${F_TMP:-}\" ]; then"
    if [ -z "$expected" ] || [ "$expected" = "empty" ]; then
      echo "  ret=\"\$(\"\$GGREP\" -Ec '.+' \$F_TMP)\""
      echo "  if [ -z \"\$ret\" ] || [ \"\$ret\" -ge 1 ]; then"
    else
      echo "  ret=\"\$(\"\$GGREP\" -Ec \"$expected\" \$F_TMP)\""
      echo "  if [ -z \"\$ret\" ] || [ \"\$ret\" -eq 0 ]; then"
    fi
    echo "    _fail Expected \"$expected\""
    echo "    N_FAIL=\$(( N_FAIL + 1 ))"
    echo "    T_FAIL=\$(( T_FAIL + 1 ))"
    echo "  else"
    echo "    _pass Matched \"$expected\""
    echo "  fi"
    echo "else"
    echo "  N_FAIL=\$(( N_FAIL + 1 ))"
    echo "fi"
  fi
done

echo "_slog"
echo "if [ \$N_FAIL -ge 1 ]; then"
echo "  _fail \"\$N_FAIL/\$N_TEST test(s) failed.\""
echo "  exit 1"
echo "else"
echo "  _pass \"All \$N_TEST tests(s) passed.\""
echo "fi"
