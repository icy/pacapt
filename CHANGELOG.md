## v3.0.7

* `lib/{apk,macports,pkgng}`: Fixed fetch option #214
* `lib/portage`: Fixed syntax error #218 (Thanks @owl4ce)

## v3.0.6

* New support `Void Linux` (Thanks Tabulate @TabulateJarl8)

## v3.0.5

* `lib/apt-cyg`: Add initial support for `apt-cyg` on Cygwin systems
* Rewrote `bin/gen_tests.rb` in `bash` (@mondeja)
* Minor typo/tests fixes

WARNING: The script won't work with docker container image
`opensuse/tumbleweed:latest`. See also
https://bugzilla.opensuse.org/show_bug.cgi?id=1190670
and https://github.com/moby/moby/pull/42836

## v3.0.4

* `lib/swupd`: Add tests and more operations (credit: @mondeja)
* `lib/conda/Qo`: added (credit: @anntzer)
* `lib/yum/Qe`: Added (credit: @mondeja)
* `yum` or `dnf`: Tests improvements (credit: @mondeja)

## v3.0.3

Minor bug fixes and features added.
More development improvements.
This release is mainly driven by @mondeja.

* Add architecture documentation
* `lib/apk/Qe`: Add (credit: @mondeja)
* `lib/dpkg/Sg`: Add (credit: @mondeja)
* `lib/yum`: Minor fixes (credit: @mondeja)
* `lib/yum/Sg`: Add (credit: @mondeja)
* `lib/zypper/Sg`: Add (credit: @mondeja)
* `tests/yum`: Add (credit: @mondeja)
* Add CI support on Github-Action for many package managers
  (`dnf`, `yum`, `homebrew`, `pkgng`, `sun_tools`)

## v3.0.2

* `tests/apk`: Add tests (Credit: @mondeja)
* `lib/*`: All `POSIX`, except `lib/cave`
* `lib/homebrew`: Fix shell switching issue (Fixes #170)
  that makes the program broken since `v3.0.0`
* `lib/dpkg/{Qc,Qe}`: Add (Credit: @mondeja)
* `lib/zypper`: `POSIX` ready, tests added, minor fixes
* `lib/zypper/Sg`: Add (credit: @mondeja)
* `lib/zypper/Sii`: Removed as it's too slow.
* Improve the way the program deals with back-end's
  optional arguments (Fixes #173)

### Deprecation

* `lib/homebrew/Rs`: temporarily deprecated
* `lib/homebrew/Qo`: temporarily deprecated

### Development

* `tests/` can run in `parallel`
* `tests` can support any custom `Dockerfile`

## v3.0.1

* More `POSIX` ports: `pkg_tools`, `conda`, `tlmgr`, `dnf`, `swupd`, `yum`, `macports`

## v3.0.0

### New features

* `lib/opkg`: Add support for `OpenWrt` (and alike)
* `Bash` is not required on `Alpine`, `SunOS` or `OpenWrt`:
  The program can work perfectly with `POSIX` shell on those systems.
* Single script can now execute within `POSIX` or `non-POSIX`
  environment and it detects/loads features dynamically.
  If the system has `bash` installed, the program switches to
  `bash` as soon as possible.

### Fixes and Updates

* `tests/`: Support new `ubuntu`/`debian` systems
* `lib/yum`, `lib/dpkg`, `lib/apk`: Fix #96, #143
  by adding  `-q` (quiet) option for `Qs`.
* `lib/00_core.sh`: POSIX going well
* `lib/zz_main.sh`: POSIX going well
* `lib/apk`:
  * Fix many implementation issues.
  * `Q` prints version information.
  * Fix `--noconfirm` issue (#150)
  * POSIX version (`pacapt-POSIX` works perfectly without `bash`)
* Remove `{apk,dnf,zypper}_Sw` methods
  and fix the `--download-only` for them

## v2.4.4

* `lib/dnf`: Minor improvements (#148)

## v2.4.3

* `lib/homebrew`: Support `cask` (fix #117)
* `tests/dpkg`: Support new distros, drop support for old distro

## v2.4.2

* Update README.md
* Support sysget-style sub commands (`pacapt install`, `pacapt upgrade`,...)
* `lib/homebrew/Rs`: Improvements (#124, @Mnkai)
* `lib/dpkg`: Use `dist-upgrade` for `Suy` and `Su` operations

## v2.4.0

* `lib/tlmgr`: Add TeXLive support (Antony Lee)
* `lib/conda`: Conda support (Antony Lee)

For developers:

* Ability to support non-system package manager (`npm`, `gem`, ...)
* Reduce shellcheck warning/error reports

## v2.3.15

* A warm up release with very minor updates.

## v2.3.14

* `lib/homebrew`: `brew upgrade` is equivalent to `brew upgrade --all`.
  See #90 and #101.
* Support `Clear Linux`. See #94.

For developers:

* Add Travis support
* Add and update test cases for Ubuntu 16.04, Ubuntu 14.04

## v2.3.13

* `lib/dpkg`: Fix `-Qs` for old `dpkg`.

For developers:

* Test scripts can now be automated thanks to `tests/*`;
* `tests/slitz40`: Add;
* `tests/dpkg`: Update.

## v2.3.12

* `lib/dpkg`: Fix #84 (incorrect implementation of `-Qs`.)

For developers:

* `bin/gen_tests.rb`: Add;
* `lib/dpkg`: Add and update test cases;
* `CONTRIBUTING`: Add new section `Writing test cases`.

## v2.3.11

* `lib/tazpkg`: Improve `-U`.

## v2.3.10

* `lib/tazpkg`: Support `-Scc`.

## v2.3.9

* `lib/tazpkg`: Support `SliTaz` distribution.

For developers:

* `contrib/*`: Add instructions to build packages on some distributions (Credit: `Pival81`).

## v2.3.8

* `lib/alpine`: Support `Alpine` distirubtion (Credit: `Carl X. Su`, `Cuong Manh Le`);
* `lib/dnf`: Support new package manager on `Fedora` system (Credit: `Huy Ngô`);
* `lib/termux`: Support `termux` on Android (Credit: `Jiawei Zhou`);
* `lib/zypper`: New option `-Sw` (Forgot to merge #72);
* `lib/yum`: New option `-Qs` (Credit: `Siôn Le Roux`);

For developers:

* Improve translation method `_translate_all`;

## v2.2.7

* `lib/zypper`: Complete query/removal options (Credit: `Janne Heß`);
* `lib/cave`: Fix an issue with `-R` option;
* New option `--noconfirm` to help non-interactive scripts (Cf. #43).
  Currently available for `pkgng`, `yum`, `dpkg` and `zypper`.

For developers:

* `lib/{00_core,zz_main}`: Refactor to support future option translation;
* Refactor code supports `-w` (download only) and `-v` (debug) options;
* Improve coding quality thanks to `shellcheck`;
* Move `compile.sh` to `bin/compile.sh`;
* Use `lib/00_core#_translate_all` to add future option translation;
* `bin/check`: Add script to inspect coding style issues (Cf. #54).

## v2.1.6

* `lib/sun_tools`: `SunOS` support (Credit: `Daniel YC Lin`);
* Fix a minor bug related to argument parsing (4287ff16e869a0960ea54233);
* Improve documentation;
* `lib/dnf`: Add some initial support;
* Adding `GREP` and `AWK` environments to future non-`Linux` systems;
* `compile.sh` will exit if it can't detect version information;
* `README` has a table of supported operations generated by `compile.sh`;
* In debug mode, `pacapt` will print body of function it would execute.

## v2.0.5

* `lib/zz_main`: Improve secondary option parsing;
* `lib/pkg_tools`: Remove `Rns` support.

## v2.0.4

* `openbsd/pkg_tools`: Add (Credit: `Somasis`);
* `homebrew/Su*`: Use `--all` flag when upgrading;
* `homebrew/*`: Some typo fixes;
* `compile.sh`: `git` becomes optional (useful for `docker` tester.);
* `compile.sh`: Get list of authors from `README.md`;
* `Makefile`: Various improvements;
* `lib/00_core`: Add `_removing_is_dangerous` method;
* `lib/00_core`: `_not_implemented` now returns `1`;
* `lib/help.txt`: Remove list of authors from help message;
* `CHANGELOG.md`: Add.

## v2.0.3

* `homebrew/Qs`: Add;
* `homebrew/*`: Fix minor bugs.

## v2.0.2

* `lib/zz_main`: Fix quoting issue (Credit: `Cuong Manh Le`).

## v2.0.1

* `git log v2.0.1`.
