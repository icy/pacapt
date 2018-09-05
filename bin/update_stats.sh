#!/usr/bin/env bash

# Purpose : Update table of implemented operations in README.md
# Author  : Ky-Anh Huynh
# License : MIT

./bin/gen_stats.sh > stats.tmp

< README.md awk '
BEGIN {
  ins = 0
}
{
  if ($0 ~ /## Implemented operations/) {
    print $0;
    ins = 1;
  }
  else {
    if ($0 ~ /##/) {
      print $0;
      ins = 0;
    }
    else if (ins == 0) {
      print $0;
    }
  }
}
' \
| sed -e '/## Implemented operations/r stats.tmp' \
> README.md.tmp

mv README.md.tmp README.md
git diff README.md
rm stats.tmp
