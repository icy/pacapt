[![Build Status](https://travis-ci.org/icy/pacapt.svg?branch=ng)](https://travis-ci.org/icy/pacapt)

## Table of contents

* [Name](#name)
* [Description](#description)
* [Installation](#installation)
  * [Install stable cript from Github](#install-stable-script-from-github)
* [Usage](#usage)
  * [Basic options](#basic-options)
  * [Basic operations](#basic-operations)
  * [Implemented Operations](#implemented-operations)
* [Related projects](#related-projects)
* [Similar projects](#similar-projects)
* [Development](#development)
* [License](#license)
* [Authors](#authors-contributors)

## Name

`pacapt` - An `ArchLinux`'s pacman-like wrapper for many package managers.

## Description

`pacapt` is an `Arch`'s pacman-like wrapper for many package managers
(system packages managers, software package managers). It's written in
`Bash` and its capacity can be extended easily. A newer version is being
developer in `Dlang` and [it's reaching an alpha release](https://github.com/icy/pacapt/tree/nd).

A sample usage of the script on `CentOS`/`Ubuntu`/`FreeBSD` machines:

    $ pacapt -S htop

The command format doesn't depend on `OS` you're working on.

Instead of remembering various options/tools on different `OS`s, you only
need a common way to manipulate packages. Not all options of the native
package manager are ported; the tool only provides a very basic interface
to search, install, remove packages, and/or update the system.

`Arch`'s pacman is chosen, because its set of operations
are simple and divided into three memorable major groups:
  `Synchronize`, `Query` and `Remove/Clean up`.

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

Non-system package manager

* `tlmgr`         by `TeX Live`
* `conda`         by [`Conda`](https://conda.io/docs/)

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

For non-system package manager, you need to create symbolic links

```
$ ln -s /usr/local/bin/pacapt /usr/local/bin/pacapt-tlmgr
$ ln -s /usr/local/bin/pacapt /usr/local/bin/pacapt-conda
```

You can also use shorter links:

```
$ ln -s /usr/local/bin/pacapt /usr/local/bin/p-tlmgr
$ ln -s /usr/local/bin/pacapt /usr/local/bin/p-conda
```

noting the suffix (e.g., `-tlmgr`, `-conda`) is mandatory.

## Usage

### Basic operations

For system package manager

* Update package database: `pacapt -Sy`
* Install a package: `pacapt -S foo`
* Search a package: `pacapt -Ss foo`
* Remove a package: `pacapt -R foo`
* Upgrade system: `pacapt -Su`
* Remove orphans: `pacapt -Sc`
* Clean up: `pacapt -Scc` or `pacapt -Sccc`

For non-system package manager: Similar as above, however you need to call correct script name, e.g.,

* Intall a Conda package: `pacapt-conda -S foo`
* Remove a Conda package: `pacapt-conda -R foo`

### Basic options

See also https://github.com/icy/pacapt/blob/ng/lib/help.txt.

Some basic command line options

* `-h` (`--help`): Print help message;
* `-P`: Print list of supported operations;
* `-V`: Print script version

Some popular options of the original `ArchLinux`'s `pacman` program
are supported and listed in the table in the next section.

A long list of options and operations can be found from [`ArchLinux`'s wiki](https://wiki.archlinux.org/index.php/Pacman/Rosetta).

### Implemented operations

```
           Q Qc Qe Qi Qk Ql Qm Qo Qp Qs Qu R Rn Rns Rs S Sc Scc Sccc Sg Si Sii Sl Ss Su Suy Sw Sy U
      apk  ~        *     *     *     *  * *  *   *  * *  *   *    *     *   *  *  *  *   *  *  * *
     cave  *        *     *     *  *  *  * *  *   *  * *  *   *    x     *         *  *   *     * x
    conda  *                               *           *  *              *         *      *
      dnf  ~  *  *  *     *  *  *  *  *  * *           *  *   *    *  *  *      *  *  *   *  *  * *
     dpkg  ~        *     *     *  *  *  * *  *   *  ~ *  *   *    *     *   *     *  *   *     * *
 homebrew  ~  *     *     *     *     *  * *         * *  *   *    *     *         *  *   *     *
 macports     *           *     *        * *         ~ *  *   *          *         *  *   *     *
    pkgng  *        *     *     *  *     * *         * *  *   *          *         *  *   *     *
pkg_tools  ~        *     *     *  *     * *  *   *  ~ *  *   x          *      *  ~  *   *     x
  portage  *  *     *     *     *        * *         * *  *   *    *     *         *  *   *     *
sun_tools  *        *     *     *     *    *                                                      *
    swupd              *        *     *    *           *                           *  *   *     *
   tazpkg  *        *     *     *          *           *  *   *                    *  *   *     * *
    tlmgr           *  *  *                *           *                 *      *  *      *       *
      yum  *  *     *     *  *  *  *  *  * *         * *  *   *    *     *   *     *  *   *     * *
   zypper  *  *     *     *  *  *  *  *  * *  *   *  * *  *   *    *     *   *  *  *  *   *  *  * *
```

**Notes:**

* `*`: Implemented;
* `~`: Implemented. Some options may not supported/implemented;
* `x`: Operation is not supported by Operating system;
* The table is generated from source. Please don't update it manually.

## Related projects

* [`batch-pacapt`](https://github.com/Grenadingue/batch-pacapt): An Arch's pacman-like package manager for Windows
* [`node-pacapt`](https://github.com/Grenadingue/node-pacapt): A node.js wrapper of pacapt + batch-pacapt

## Similar projects

* [`sysget`](https://github.com/emilengler/sysget)

## Development

### Read me first

The following message is published on project's Gitter group on Oct 09th 2018.

> Hi everyone, long time no see :) I've not been using Gitter IM actively as it's not very convenient on my browser, and Gitter requires a lot of access grants to my Github profile ^.^
>
> I've rewritten pacapt in Dlang (https://github.com/icy/pacapt/tree/nd). There are two issues remained: (1) passthrough option (2) publish artifacts (32bit binary, 64 bit binary, arm support,...) to Github/S3. I'm not sure there is any way to make this latest CI step simple and secure (Dlang hasn't had good Reproducible build yet.) Using S3 is not persistent, Github requires my personal API token...
>
> The primary motivation of rewriting pacapt in Dlang is to support some restricted environment where Bash is not available. I picked Dlang simply it's the language I'm studying. The major parts of the project (lib/*.sh) are still in shell format. To be specific, the (binary) executable file will help to handle users' arguments and the actual steps are delegated to system shell(s).
>
> The current stable branch (ng) still accepts active development, however it would become legacy when `nd` is released. Cherry-picks are required to make contributors' works on `ng` available on `nd` branch. (In case the names are confusing you, here is a tip: `ng` sounds like next generation, while `nd` emphasizes Dlang use.)
>
> Feel free to take a look. Any comments are appreciated.
>
> Thx

### General steps

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
* Antony Lee (anntzer)
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
