[![Build Status](https://travis-ci.org/icy/pacapt.svg?branch=ng)](https://travis-ci.org/icy/pacapt)

## Table of contents

* [Name](#name)
* [Description](#description)
* [Installation](#installation)
  * [Install stable from Github](#install-stable-script-from-github)
  * [Installation from Pival81 repository](#installation-from-pival81-repository)
* [Usage](#usage)
* [Implemented Operations](#implemented-operations)
* [Related projects](#related-projects)
* [Development](#development)
* [License](#license)
* [Authors](#authors-contributors)

## Name

`pacapt` - An `Arch`'s pacman-like package manager for some `Unices`.

## Description

An `Arch`'s pacman-like package manager for some `Unices`.
Actually this `Bash` script provides a wrapper for system's package manager.
For example, on `CentOS` machines, you can install `htop` with command

    $ pacapt -S htop

Instead of remembering various options/tools on different `OS`s, you only
need a common way to manipulate packages. Not all options of the native
package manager are ported; the tool only provides a very basic interface
to search, install, remove packages, and/or update the system.

`Arch`'s pacman is chosen, as pacman is quite smart when it divides all
packages-related operations into three major groups:
  `Synchronize`, `Query` and `Remove/Clean up`.
It has a clean man page, and it is the only tool needed to manipulate
official packages on system.
(`Debian`, for example, requires you to use `apt-get`, `dpkg`, and/or `aptitude`.)

The tool supports the following package managers:

* `pacman`        by `Arch Linux`, `ArchBang`, `Manjaro`, etc.
* `dpkg/apt-get`  by `Debian`, `Ubuntu`, etc.
* `homebrew`      by `Mac OS X`
* `macports`      by `Mac OS X`
* `yum/rpm`       by `Redhat`, `CentOS`, `Fedora`, etc.
* `portage`       by `Gentoo`
* `zypper`        by `OpenSUSE`
* `pkgng`         by `FreeBSD`
* `cave`          by `Exherbo Linux`
* `pkg_tools`     by `OpenBSD`
* `sun_tools`     by `Solaris(SunOS)`
* `apk`           by `Alpine Linux`
* `tazpkg`        by `SliTaz Linux`
* `swupd`         by `Clear Linux`

## Installation

1. This script shouldn't be installed on an Arch-based system;
2. On `FreeBSD` and `Alpine Linux`, please install `bash` package first.

### Install stable script from Github

You can download the stable script and make it executable

````
$ sudo wget -O /usr/local/bin/pacapt \
https://github.com/icy/pacapt/raw/ng/pacapt

$ sudo chmod 755 /usr/local/bin/pacapt

$ sudo ln -sv /usr/local/bin/pacapt /usr/local/bin/pacman || true
````

On some system, `/usr/local/bin` is not in the search paths when the
command is executed by `sudo`. You may want to use `/usr/bin/pacman`
or `/usr/bin/pacapt` instead.

This stable script is generated from the latest stable branch,
which is `v2.0` at the moment. If you want to compile a script
from its components, please make sure you use a correct branch.
See `CONTRIBUTING.md` for details.

### Installation from Pival81 repository

@Pival81 creates specification to build packages on various Linux
distributions (CentOS, Debian, Fedora, OpenSUSE, RHEL, Ubuntu).
The specification can be found under the `contrib/` directory.

@Pival81 also builds packages which are ready to use on your machine.
See the following link for details.

  http://software.opensuse.org/download.html?project=home:Pival81&package=pacapt

## Usage

Some basic command line options

* `-h` (`--help`): Print help message;
* `-P`: Print list of supported operations;
* `-V`: Print script version

Some popular options of the original `ArchLinux`'s `pacman` program
are supported and listed in the table in the next section.

A short description can be found at

  https://github.com/icy/pacapt/blob/ng/lib/help.txt.

## Implemented operations

```
           Q Qc Qi Qk Ql Qm Qo Qp Qs Qu R Rn Rns Rs S Sc Scc Sccc Si Sii Sl Ss Su Suy Sw Sy U
      apk  ~     *     *     *     *  * *  *   *  * *  *   *    *  *   *  *  *  *   *  *  * *
     cave  *     *     *     *  *  *  * *  *   *  * *  *   *    x  *         *  *   *     * x
      dnf  ~  *  *     *  *  *  *  *  * *           *  *   *    *  *      *  *  *   *  *  * *
     dpkg  ~     *     *     *  *  *  * *  *   *  ~ *  *   *    *  *   *     *  *   *     * *
 homebrew  ~  *  *     *     *     *  * *         * *  *   *    *  *         *  *   *     *  
 macports     *        *     *        * *         ~ *  *   *       *         *  *   *     *  
    pkgng  *     *     *     *  *     * *         * *  *   *       *         *  *   *     *  
pkg_tools  ~     *     *     *  *     * *  *   *  ~ *  *   x       *      *  ~  *   *     x  
  portage  *  *  *     *     *        * *         * *  *   *    *  *         *  *   *     *  
sun_tools  *     *     *     *     *    *                                                   *
    swupd           *        *     *    *           *                        *  *   *     *  
   tazpkg  *     *     *     *          *           *  *   *                 *  *   *     * *
     xbps  *     *     *     *  *  *  * *  *   *  * *  *   *    *  *   *     *  *   *  *  * *
      yum  *  *  *     *  *  *  *  *  * *         * *  *   *    *  *   *     *  *   *     * *
   zypper  *  *  *     *  *  *  *  *  * *  *   *  * *  *   *    *  *   *  *  *  *   *  *  * *
```

**Notes:**

* `*`: Implemented;
* `~`: Implemented. Some options may not supported/implemented;
* `x`: Operation is not supported by Operating system;
* The table is generated from source. Please don't update it manually.

## Related projects

* [A node.js wrapper of pacapt](https://github.com/Grenadingue/node-pacapt)
* [An Arch's pacman-like package manager for Windows](https://github.com/Grenadingue/batch-pacapt)
* [A node.js wrapper of pacapt plus batch-pacapt](https://github.com/Grenadingue/node-pacapt)

## Development

Make sure you read some instructions in `CONTRIBUTING.md`.

A development script can be compiled from the source code.

````
$ git clone https://github.com/icy/pacapt.git
$ cd pacapt

# switch to development branch
$ git checkout ng

# compile the script
$ ./bin/compile.sh > pacapt.dev

# check if syntax is good
$ bash -n pacapt.dev

$ sudo install -m755 ./pacapt.dev /usr/local/bin/pacapt
````

Please read the sample `Makefile` for some details.

## License

This work is released under the terms of Fair license
(http://opensource.org/licenses/fair).

## AUTHORS. CONTRIBUTORS

Many people have contributed to the project by sending pull requests
and/or reporting on the ticket system. Here is an incomplete list of
authors and contributors.

* 10sr (10sr)
* Alexander Dupuy (dupuy)
* Anh K. Huynh (icy)
* Alex Lyon (Arcterus)
* Carl X. Su (bcbcarl)
* Cuong Manh Le (Gnouc)
* Daniel YC Lin (dlintw)
* Danny George (dangets)
* Darshit Shah (darnir)
* Dmitry Kudriavtsev (dkudriavtsev)
* Eric Crosson (EricCrosson)
* Evan Relf (evanrelf)
* GijsTimmers (GijsTimmers)
* Hà-Dương Nguyễn (cmpitg)
* Huy Ngô (NgoHuy)
* James Pearson (xiongchiamiov)
* Janne Heß (dasJ)
* Jiawei Zhou (4679)
* Karol Blazewicz
* Kevin Brubeck (unhammer)
* Konrad Borowski (xfix)
* Kylie McClain (somasis)
* Valerio Pizzi (Pival81)
* Siôn Le Roux (sinisterstuf)
* Thiago Perrotta (thiagowfx)
* Vojtech Letal (letalvoj)
