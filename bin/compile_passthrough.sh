#!/usr/bin/env bash

# Purpose : Extract Passthrough information
cd "$(dirname "${BASH_SOURCE[0]:-.}")/../lib/" || exit 1
grep PASSTHROUGH * \
| awk -F '[ =.]' \
    '{printf("export %s_passthrough=%s\n", $1, $NF)}'
