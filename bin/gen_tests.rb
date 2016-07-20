#!/usr/bin/env ruby

# Purpose: Generate test scripts
# Author : Anh K. Huynh
# License: MIT
# Date   : 2016 July 18th
# Example:
#
#   $ ruby -n ./bin/gen_tests.rb < lib/dpkg.txt > ./test.sh
#   $ docker run \
#       -v $PWD/test.sh:/tmp/test.sh \
#       -v $PWD/pacapt.dev:/usr/bin/pacman \
#       ubuntu:14.04 \
#       /bin/sh /tmp/test.sh 2>test.log
#

BEGIN {
  new_test = true
  puts "#!/bin/sh"
  puts "N_TEST=0"
  puts "N_FAIL=0"
  puts ""
  puts "_log()  { echo 1>&2; echo \":: $*\" 1>&2 ; }"
  puts "_fail() { _log \"Fail $*\"; echo -e \"\\e[0;31mFail:\\e[0m $*\"; }" # red
  puts "_erro() { _log \"Erro $*\"; echo -e \"\\e[0;31mErro:\\e[0m $*\"; }" # red
  puts "_info() { _log \"Info $*\"; echo -e \"\\e[0;36mInfo:\\e[0m $*\"; }" # cyan
  puts "_pass() { _log \"Pass $*\"; echo -e \"\\e[0;36mPass:\\e[0m $*\"; }" # cyan
  puts "_exec() { _log \"Exec $*\"; echo -e \"\\e[0;33mExec:\\e[0m $*\"; }" # yellow
  puts "_warn() { _log \"Warn $*\"; echo -e \"\\e[0;33mWarn:\\e[0m $*\"; }" # yellow
}

if gs = $_.match(/^in(.*)/)
  if new_test
    puts ""
    outputs = []
    new_test = false

    puts "if [ -n \"${F_TMP:-}\" ]; then"
    puts "  rm -f \"${F_TMP}\""
    puts "fi"
    puts "export F_TMP=\"$(mktemp)\""
    puts "if [ -z ${F_TMP:-} ]; then"
    puts "  _fail 'Unable to create temporary file.'"
    puts "fi"
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

  puts "if [ -n \"${F_TMP:-}\" ]; then"
  puts "  _exec \"#{cmd} (log: $F_TMP)\""
  puts "  { #{cmd} ; } 2>&1 | tee -a $F_TMP 1>&2"
  puts "fi"

elsif gs = $_.match(/^ou(.*)/)
  new_test = true
  expected = gs[1].strip

  puts "N_TEST=$(( N_TEST + 1 ))"
  puts "if [ -n \"${F_TMP:-}\" ]; then"
  if expected.empty? or expected == "empty"
    puts "  ret=\"`grep -Ec '.+' $F_TMP`\""
    puts "  if [ $ret -ge 1 ]; then"
  else
    puts "  ret=\"`grep -Ec \"#{expected}\" $F_TMP`\""
    puts "  if [ $ret -eq 0 ]; then"
  end
  puts "    _fail 'Expected \"#{expected}\"'"
  puts "    N_FAIL=$(( N_FAIL + 1 ))"
  puts "  else"
  puts "    _pass 'Matched \"#{expected}\"'"
  puts "  fi"
  puts "else"
  puts "  N_FAIL=$(( N_FAIL + 1 ))"
  puts "fi"
end

END {
  puts "if [ $N_FAIL -ge 1 ]; then"
  puts "  _fail \"$N_FAIL/$N_TEST test(s) failed.\""
  puts "  exit 1"
  puts "else"
  puts "  _pass \"All $N_TEST tests(s) passed.\""
  puts "fi"
}
