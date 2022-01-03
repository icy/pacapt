## `pacapt` - An `ArchLinux`'s pacman-like wrapper for many package managers

[![Build Status](https://github.com/icy/pacapt/actions/workflows/ci.yaml/badge.svg)](https://github.com/icy/pacapt/actions)

`pacapt` is a 56KB `shell` wrapper for many package managers.
Simply install package with `pacapt -S htop` or `pacapt install htop`
on any `Linux`, `BSD`, `OpenWrt` or `Mac OS` machines.
It supports the following package managers:

* `pacman`        from `Arch Linux`-based systems, `ArchBang`, `Manjaro`, etc.
* `apt-cyg`       from Cygwin (via [apt-cyg](https://github.com/transcode-open/apt-cyg))
* `apt-get`       from `Debian`, `Ubuntu`, etc.
* `homebrew`      from `Mac OS X`
* `macports`      from `Mac OS X`
* `yum/rpm`       from `Redhat`, `CentOS`, `Fedora`, `Oracle Linux`, etc.
* `portage`       from `Gentoo`
* `zypper`        from `OpenSUSE`
* `pkgng`         from `FreeBSD`
* `cave`          from `Exherbo Linux`
* `pkg_tools`     from `OpenBSD`
* `sun_tools`     from `Solaris(SunOS)`
* `apk`           from `Alpine Linux`
* `opkg`          from `OpenWrt`
* `tazpkg`        from `SliTaz Linux`
* `swupd`         from `Clear Linux`
* `xbps`          from `Void Linux`
* `tlmgr`         from `TeX Live`
* `conda`         from [`Conda`](https://conda.io/docs/)

## TOC

- [Description](#pacapt---an-archlinuxs-pacman-like-wrapper-for-many-package-managers)
- [Installation](#installation)
  - [Install the stable script from Github](#install-the-stable-script-from-github)
- [Usage](#usage)
  - [Basic operations](#basic-operations)
  - [Basic options](#basic-options)
  - [Implemented operations](#implemented-operations)
- [Related projects](#related-projects)
- [Similar projects](#similar-projects)
- [Development](#development)
  - [General steps](#general-steps)
- [License](#license)
- [Authors and Contributors](#authors-contributors)

## Installation

This script shouldn't be installed on an Arch-based system.
On `cave`-based system, `bash` is required.

### Install the stable script from Github

You can download the stable script and make it executable.
On non-Arch-based system, you may use `pacman` as script name instead of `pacapt`.

````
$ sudo wget -O /usr/local/bin/pacapt \
    https://github.com/icy/pacapt/raw/ng/pacapt

$ sudo chmod 755 /usr/local/bin/pacapt

$ sudo ln -sv /usr/local/bin/pacapt /usr/local/bin/pacman || true
````

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

* Update package database: `pacapt -Sy`, or `pacapt update`
* Install a package: `pacapt -S foo`, or `pacapt install foo`
* Search a package: `pacapt -Ss foo`, or `pacapt search foo`
* Remove a package: `pacapt -R foo`, or `pacapt remove foo`
* Upgrade system: `pacapt -Su`, or `pacapt upgrade`
* Remove orphans: `pacapt -Sc`, or `pacapt autoremove foo`
* Clean up: `pacapt -Scc` or `pacapt -Sccc`, or `pacapt clean`

For non-system package manager: Similar as above, however you need to call correct script name, e.g.,

* Install a Conda package: `pacapt-conda -S foo`
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
           Q Qc Qe Qi Qk Ql Qm Qo Qp Qs Qu R Rn Rns Rs S Sc Scc Sccc Sg Si Sii Sl Ss Su Suy Sy U
      apk  ~     *  *     *     *     *  * *  *   *  * *  *   *    *     *   *  *  *  *   *  * *
  apt_cyg  *        *     *                *           *                           *         *
     cave  *        *     *     *  *  *  * *  *   *  * *  *   *    x     *         *  *   *  * x
    conda  *                    *          *           *  *              *         *      *
      dnf  ~  *  *  *     *  *  *  *  *  * *           *  *   *    *  *  *   *  *  *  *   *  * *
     dpkg  ~  *  *  *  *  *     *  *  *  * *  *   *  ~ *  *   *    *  *  *   *     *  *   *  * *
 homebrew  *  *     *     *           *  * *           *  *   *    *     *         *  *   *  *
 macports     *           *     *        * *         ~ *  *   *          *         *  *   *  *
     opkg  *        *     *     *     *  * *           *                 *   *     *  *      * *
    pkgng  *        *     *     *  *     * *         * *  *   *          *         *  *   *  *
pkg_tools  ~        *     *     *  *     * *  *   *  ~ *  *   x          *      *  ~  *   *  x
  portage  *  *     *     *     *        * *         * *  *   *    *     *         *  *   *  *
sun_tools  *        *     *     *     *    *                                                   *
    swupd  *        *  *        *     *    *           *  *   *                    *  *   *  *
   tazpkg  *        *     *     *          *           *  *   *                    *  *   *  * *
    tlmgr           *  *  *                *           *                 *      *  *      *    *
     xbps  *     *  *     *     *     *    *           *      *                    *  *   *  *
      yum  *  *  *  *     *  *  *  *  *  * *         * *  *   *    *  *  *   *     *  *   *  * *
   zypper  *  *     *     *  *  *  *  *  * *  *   *  * *  *   *    *  *  *   *  *  *  *   *  * *
```

**Notes:**

* `*`: Implemented;
* `~`: Implemented. Some options may not supported/implemented;
* `x`: Operation is not supported by Operating system;
* The table is generated from source. Please don't update it manually.

## Related projects

* [`batch-pacapt`](https://github.com/Grenadingue/batch-pacapt): An Arch's pacman-like package manager for Windows
* [`node-pacapt`](https://github.com/Grenadingue/node-pacapt): A node.js wrapper of pacapt + batch-pacapt
* `pacapt`'s [`nd`](https://github.com/icy/pacapt/tree/nd) branch: A rewrite in Dlang, now deprecated.
* [`pacapt-py`](https://github.com/rami3l/pacapt-py): A proof of concept in Python to provide pacapt-like experience to Homebrew.
* [`pacapt-go`](https://github.com/rami3l/pacaptr/tree/go-dev): A more complete rewrite in Go, now lives in the [`go-dev`](https://github.com/rami3l/pacaptr/tree/go-dev) branch of `pacaptr` as legacy code.

## Similar projects

* [`sysget`](https://github.com/emilengler/sysget) is `a front-end for every package manager`, written in `C++`. It provides some basic features to manipulate packages on your system.
* [`pacaptr`](https://github.com/rami3l/pacaptr) was originally started as a `Rust` port of this project (`pacapt`) (See also #126), now it's growing with their own new features and support.

## Development

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

* 10sr (@10sr)
* Alexander Dupuy (@dupuy)
* Anh K. Huynh (@icy)
* Antony Lee (@anntzer)
* Alex Lyon (@Arcterus)
* Álvaro Mondéjar (@mondeja)
* Carl X. Su (@bcbcarl)
* Cuong Manh Le (@Gnouc)
* Daniel YC Lin (@dlintw)
* Danny George (@dangets)
* Darshit Shah (@darnir)
* Dmitry Kudriavtsev (@dkudriavtsev)
* Eric Crosson (@EricCrosson)
* Evan Relf (@evanrelf)
* GijsTimmers (@GijsTimmers)
* Hà-Dương Nguyễn (@cmpitg)
* Huy Ngô (@NgoHuy)
* James Pearson (@xiongchiamiov)
* Janne Heß (@dasJ)
* Jiawei Zhou (@4679)
* Karol Blazewicz
* Kevin Brubeck (@unhammer)
* Konrad Borowski (@xfix)
* Kylie McClain (@somasis)
* Gen Li (@Rami3L)
* Valerio Pizzi (@Pival81)
* Siôn Le Roux (@sinisterstuf)
* Tabulate (@TabulateJarl8)
* Thiago Perrotta (@thiagowfx)
* Vojtech Letal (@letalvoj)
