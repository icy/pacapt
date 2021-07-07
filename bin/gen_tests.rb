#!/usr/bin/env ruby

# Purpose: Generate test scripts
# Author : Anh K. Huynh
# License: MIT
# Date   : 2016 July 18th
# Example:
#
#   $ ruby -n ./bin/gen_tests.rb < lib/dpkg.txt > ./test.sh
#   $ docker run --rm \
#       -v $PWD/test.sh:/tmp/test.sh \
#       -v $PWD/pacapt.dev:/usr/bin/pacman \
#       -e "MSG_PREFIX=:: (INFO) " \
#       ubuntu:14.04 \
#       /bin/sh /tmp/test.sh 2>test.log
#

BEGIN {
  new_test = true

  puts "#!/bin/sh"
  puts ""
  puts "# Notes: This file is generated. Please don't modify them manually."
  puts ""
  puts "export PATH=/sbin:/bin:/usr/sbin:/usr/bin:$PATH"
  puts ""
  puts "N_TEST=0  # Total number of tests"
  puts "N_FAIL=0  # Number of failed tests"
  puts "F_TMP=    # Temporary file"
  puts "T_FAIL=0  # Number of failed tests in current block"
  puts ""
  puts "set -u"
  puts ""
  #
  # Just send message to STDERR
  #
  # When CI is set, we expect the current test script is executed directly
  # by Github-Runner shell (not via our Docker launcher.)
  # This is the case for non-docker tests (homebrew, pkgng).
  # We need to reduce the duplicate log message in these cases.
  #
  puts "_log()  { if [ -z \"${CI:-}\" ]; then echo \"$*\" 1>&2 ; fi; }"

  # A fancy wrappers of _log
  #
  # Where there is any message, we need to ensure they are on both
  # channels (STDIN, STDERR). Normally, the STDERR has more verbose
  # information, i.e, the output of all executions. The STDERR will
  # be [often] captured for later investigation and it's done via
  # the `tests/test.sh`. From STDIN we try to keep it compact.
  # ...
  #
  puts "_fail() { _log \"${MSG_PREFIX}Fail: $*\"; printf \"${MSG_PREFIX}\e[31mFail\e[0m: %s\n\" \"$*\"; }" # red
  puts "_erro() { _log \"${MSG_PREFIX}Erro: $*\"; echo \"${MSG_PREFIX}Erro: $*\"; }" # red
  puts "_info() { _log \"${MSG_PREFIX}Info: $*\"; echo \"${MSG_PREFIX}Info: $*\"; }" # cyan
  puts "_pass() { _log \"${MSG_PREFIX}Pass: $*\"; echo \"${MSG_PREFIX}Pass: $*\"; }" # cyan
  puts "_exec() { _log \"${MSG_PREFIX}Exec: $*\"; echo \"${MSG_PREFIX}Exec: $*\"; }" # yellow
  puts "_warn() { _log \"${MSG_PREFIX}Warn: $*\"; echo \"${MSG_PREFIX}Warn: $*\"; }" # yellow

  # Create a secure log (file) stream. If the file was set in $F_TMP
  # we print out all output and remove that too.
  puts "_slog() {"
  puts "  if [ -n \"${F_TMP:-}\" ]; then"
  # ...
  # but when our test fails, we also print the first 100 lines to
  # the STDOUT, so that we can see them quickly. It can be tricky
  # when  homebrew/pkgng fails, because we don't have any access
  # to MacOS environment on github-action runner. But let's see...
  puts "    if [ $T_FAIL -ge 1 ]; then"
  puts "      _info 'Exec. output:'"
  puts "      if [ -z \"${CI:-}\" ]; then"
  puts "        1>&2 cat $F_TMP"
  puts "      fi"
  puts "      cat $F_TMP \\"
  puts "      | awk '{ if (NR <= 100) { printf(\" > %s\\n\", $0); }}"
  puts "         END { if (NR > 100) { printf(\" > ...\\n\");}}'"
  puts "    fi"
  puts "    rm -f \"${F_TMP}\""
  puts "    echo 1>&2"
  puts "    export T_FAIL=0"
  puts "  else"
  puts "    export T_FAIL=0"
  puts "    export F_TMP=\"$(mktemp)\""
  puts "    if [ -z \"${F_TMP:-}\" ]; then"
  puts "      _fail 'Unable to create temporary file.'"
  puts "    fi"
  puts "  fi"
  puts "}"
}

if gs = $_.to_s.match(/^in(.*)/)
  if new_test
    puts ""
    outputs = []
    new_test = false
    puts "_slog"
  end

  cmd = gs[1].strip.gsub("\$LOG", "$F_TMP")

  cmd = \
  case cmd
  when "clear" then
    "echo > $F_TMP"
  when /\A! (.+)\z/ then
    "#{$1.strip}"
  else
    "pacman #{cmd}"
  end

  # FIXME: We wanted to use `tee` here, but that will create new pipes,
  # FIXME: and hence some feature didn't work (e.g., export FOO=).
  puts "if [ -n \"${F_TMP:-}\" ]; then"
  puts "  _exec \"#{cmd}\""
  puts "  { #{cmd} ; } 1>>$F_TMP 2>&1"
  puts "fi"

elsif gs = $_.to_s.match(/^ou(.*)/)
  new_test = true
  expected = gs[1].strip

  puts "N_TEST=$(( N_TEST + 1 ))"
  puts "if [ -n \"${F_TMP:-}\" ]; then"
  if expected.empty? or expected == "empty"
    puts "  ret=\"$(grep -Ec '.+' $F_TMP)\""
    puts "  if [ -z \"$ret\" ] || [ \"$ret\" -ge 1 ]; then"
  else
    puts "  ret=\"$(grep -Ec \"#{expected}\" $F_TMP)\""
    puts "  if [ -z \"$ret\" ] || [ \"$ret\" -eq 0 ]; then"
  end
  puts "    _fail Expected \"#{expected}\""
  puts "    N_FAIL=$(( N_FAIL + 1 ))"
  puts "    T_FAIL=$(( T_FAIL + 1 ))"
  puts "  else"
  puts "    _pass Matched \"#{expected}\""
  puts "  fi"
  puts "else"
  puts "  N_FAIL=$(( N_FAIL + 1 ))"
  puts "fi"
end

END {
  puts "_slog"
  puts "if [ $N_FAIL -ge 1 ]; then"
  puts "  _fail \"$N_FAIL/$N_TEST test(s) failed.\""
  puts "  exit 1"
  puts "else"
  puts "  _pass \"All $N_TEST tests(s) passed.\""
  puts "fi"
}
