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
#       /bin/bash -c /tmp/test.sh
#

BEGIN {
  new_test = true
  puts "#!/bin/bash"
  puts "set +x"
  puts "N_TEST=0"
  puts "N_FAIL=0"
}

if gs = $_.match(/^# test\.in(.*)/)
  if new_test
    puts ""
    outputs = []
    new_test = false

    puts "if [[ -n ${F_TMP:-} ]]; then"
    puts "  rm -f \"${F_TMP}\""
    puts "fi"
    puts "export F_TMP=\"$(mktemp)\""
    puts "if [[ -z ${F_TMP:-} ]]; then"
    puts "  echo 'Fail: Unable to create temporary file.'"
    puts "fi"
  end

  cmd = gs[1].strip

  cmd = \
  case cmd
  when "clear" then "echo > $F_TMP"
  else "pacman #{cmd}"
  end

  puts "if [[ -n ${F_TMP:-} ]]; then"
  puts "  echo \"Exec: #{cmd}\""
  puts "  #{cmd} 2>&1 | tee -a $F_TMP"
  puts "fi"

elsif gs = $_.match(/^# test\.ou(.*)/)
  new_test = true
  expected = gs[1].strip

  puts "(( N_TEST ++ ))"
  puts "if [[ -n ${F_TMP:-} ]]; then"
  if expected.empty? or expected == "empty"
    puts "  ret=\"$(grep -Ec '.+' $F_TMP)\""
    puts "  if [[ $ret -ge 1 ]]; then"
  else
    puts "  ret=\"$(grep -Ec \"#{expected}\" $F_TMP)\""
    puts "  if [[ $ret -eq 0 ]]; then"
  end
  puts "    echo 'Fail: Expected \"#{expected}\"'"
  puts "    (( N_FAIL ++ ))"
  puts "  else"
  puts "    echo 'Pass: \"#{expected}\"'"
  puts "  fi"
  puts "else"
  puts "  (( N_FAIL ++ ))"
  puts "fi"
end

END {
  puts "if [[ $N_FAIL -ge 1 ]]; then"
  puts "  echo \"Warn: $N_FAIL/$N_TEST test(s) failed.\""
  puts "  exit 1"
  puts "else"
  puts "  echo \"Info: All $N_TEST tests(s) passed.\""
  puts "fi"
}
