# Purpose: Provide help message
# Author : Anh K. Huynh
# License: Fair license (http://www.opensource.org/licenses/fair)
# Source : http://github.com/icy/pacapt/

# Copyright (C) 2010 - 2014 Anh K. Huynh
#
# Usage of the works is permitted provided that this instrument is
# retained with the works, so that any entity that uses the works is
# notified of this instrument.
#
# DISCLAIMER: THE WORKS ARE WITHOUT WARRANTY.

_help() {
  cat <<-EOF
NAME
  pacapt - An Arch's pacman-like package manager for some Unices.
  More details can be found at https://github.com/icy/pacapt .

SYNTAX

  $ pacapt <operation(s)> <option(s)> <packages>

OPERATIONS

  Query
    -Q              list all installed packages
    -Qc <package>   show package's changelog
    -Qi <package>   print package status
    -Ql <package>   list package's files
    -Qm             list installed packages that aren't available
                    in any installation source
    -Qo <file>      query package that provides <file>
    -Qp <file>      query a package file (don't use package database)
    -Qs <package>   search for installed package

  Synchronize
    -S <package>    install package(s)
    -Ss <package>   search for packages
    -Su             upgrade the system
    -Sy             update package database
    -Suy            update package database, then upgrade the system

  Remove / Clean up
    -R <packages>   remove some packages
    -Sc             delete old downloaded packages
    -Scc            delete all downloaded packages
    -Sccc           clean variant files.
                    (debian) See also http://dragula.viettug.org/blogs/646

  Miscellaneous

    -h or --help    print this help message
    -P              print supported operations

OPTIONS

    -w              download packages but don't install them

EXAMPLES

  1. To install a package from Debian's backports repository

      $ pacapt -S foobar -t lenny-backports
      $ pacapt -S -- -t lenny-backports foobar

  2. To update package database and then update your system

      $ pacapt -Syu

  3. To download a package without installing it

      $ pacapt -Sw foobar

NOTES

  When being executed on Arch-based system, the tool simply invokes
  the system package manager (`/usr/bin/pacman`.)

  Though you can specify option by its own word, for example,

      $ pacapt -S -y -u

  it's always the best to combine them

      $ pacapt -Syu

AUTHORS

  The script was written Anh K. Huynh. Some developers and system admin-
  strator have contributed to the script. See THANKS for details.
EOF
}
