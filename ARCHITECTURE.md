## TOC

- [ ] [Introduction](#introduction)
- [ ] [Components](#components)
    - [ ] [`pacapt`](#pacapt)
    - [ ] [`lib`](#lib)
    - [ ] [`tests`](#tests)
    - [ ] [CI with github-action](#ci-with-github-action)
    - [ ] [`bin`](#bin)
- [ ] [History. Languages](#history-languages)

## Introduction

This documentation is about the design of `pacapt` program.
It describes how some components are connected to each other.
And it's useful if you want to learn to contribute/improve the project.

`pacapt` is just small program, with a bunch of scripts.
There is no such thing `architecture`; the name is inspired by
the HN topic https://news.ycombinator.com/item?id=26048784

## Components

### `pacapt`

[`pacapt`](pacapt) is our main program.
It's a shell wrapper for many package managers on your system/OS,
and now works perfectly in `POSIX` environment (except a few exceptions).

But we don't make changes in `pacapt` directly. The program is actually
generated for every new release, and it's considered the _stable_
version where everyone can easily download it (with `curl` or `wget`)
on their system.

### `lib`

The [`lib`](lib/) directory contains all shell scripts that would be
combined into the main program `pacapt`. Each package manager has their
own (separate) library file, for example [`lib/apk.sh`](lib/apk.sh)
contains all code used on `Alpine`-based system.

Other than that, there are a few important/essential files:

* [`00_core.sh`](lib/00_core.sh):
    Contains DRY functions to be used in any other places.
* [`00_external.sh`](lib/00_external.sh):
    Contains some script to support non-system package managers
    (`pip`, `npm`)
* [`zz_main.sh`](lib/zz_main.sh):
    Contains an argument parser, shell switching (change from `sh`
    to `bash` if necessary), and invocations of the real back-end
    package manager.
* The help contents are provided in a plain text
  file [`lib/help.txt`](lib/help.txt).

### `tests`

Contains all tests files written in a simple `DSL`. Some useful information
about them can be read from [`tests/README.md`](tests/README.md).
See real examples in [`tests/dpkg.txt`](tests/dpkg.txt) (this is one
of the richest test files we have).

### `bin`

Contains two important scripts

* [`compile.sh`](bin/compile.sh): Glue all files under `lib` directory
  and create the main program `pacapt`. It's also used to generate
  a development version of the script: Please check out
  `make pacapt.dev` for more details
* [`gen_tests.sh`](bin/gen_tests.sh): To deal with our tests DSL
  as mentioned in the section [`tests`](#tests)

The very tricky program [`bin/gen_stats.sh`](bin/gen_stats.sh)
is used to generate the table of all supported operations that you see from
the [README.md](README.md#implemented-operations). The algorithm
was designed and implemented _once_ and since then no further change
has ever been made :D Well, it's so scary to touch that part,
as long as it's working.
It requires all methods in [`lib/`](lib/) to follow a strict syntax
which you can see from the code:

```
    <(
      # shellcheck disable=2016
      $GREP -hE "^${_PKGNAME}_[^ \\t]+\\(\\)" "$L" \
       | $AWK -F '(' '{print $1}'
    )
```

Don't worry. As long as you define a shell method as below, it's fine:

```
# method_name, follows by (), then a space, then a {
my_method() {
  : the body of the method
}
```

### CI with github-action

Please visit the self-doc YAML file [`.github/workflows/ci.yaml`](.github/workflows/ci.yaml).

## History. Languages

The first implementation was submitted in 2010.

The project is using

* `Ruby`
* `Perl`
* `Bourne` and `Bourne-Again` shell scripting language
* `Dockerfile`
* (GNU) `parallel`, `awk`, `sed`, `grep`
* `Dlang` on some deprecated branches
* its own DSL for test files
* `Markdown` (Github format)
* `English`

:P
