## Table of contents

1. [The design of the program](ARCHITECTURE.md)
1. [Coding style](#coding-style)
1. [Testing. Writing test cases](#testing-writing-test-cases)
1. [Generating pacapt script](#generating-pacapt-script)
1. [Branches](#branches)
1. [Closed branches](#closed-branches)

## Coding style

1. Don't use tab or smart tab;
1. Use `2-space` instead of a tab;
1. Contribute to library file under `./lib/` directory;
1. We try to follow the convention from:
    https://github.com/icy/bash-coding-style.

## Testing. Writing test cases

See also `tests/README.md` and https://github.com/icy/pacapt/actions.

1. Use `make shellcheck POSIX` if you have shellcheck
   and enough `Perl` packages (`JSON`, `URI::Escape`) on your system;
1. Use `PACAPT_DEBUG=foo` where `foo` is a package manager
   (`dpkg`, `pacman`, `zypper`, ...) to print what `pacapt` will do.
   Use `PACAPT_DEBUG=auto` for auto-detection;
1. You can use `docker` for testing, by mounting the `pacapt.dev` script
   to the container. See also `docker.i` section in `Makefile`. Example:

````
$ make pacapt.dev
$ docker run --rm -ti \
    -v $PWD/pacapt.dev:/usr/bin/pacman \
    debian:stable /bin/bash
# Your container's shell is available from this point
````

Alternatively you can use the `Makefile`

```
$ make docker.i DISTRO=debian:stable
# # Your Bourne shell is available now
# # Type `bash` to start more convenient interactive shell.
```

## Generating `pacapt.dev` script

1. For your development, use `make pacapt.dev`;
1. Please **do not** use `make pacapt` to update `pacapt`,
   and/or modify it manually;

## Branches

1. `ng`:
    The current development branch.
    Some pull requests are merged on to this branch,
    but the work may not be ready for production.
1. `your feature branch`:
    For new feature or bug fix, please work on your own branch
    and create pull request.
    Do not put different ideas on a same branch
    because that makes future tracking harder.

## Closed branches

1. `master`:
    The old stable code of the `pacapt`.
    This branch is closed on May 4th, 2014.
