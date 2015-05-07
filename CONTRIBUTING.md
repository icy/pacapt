## Coding style

1. Don't use tab or smart tab
2. Use `2-space` instead of a tab
3. Contribute to library file under `./lib/` directory
5. We try to follow the convention from
    https://github.com/icy/bash-coding-style

## Testing. Docker

5. Use `PACAPT_DEBUG=foo` where `foo` is a package manager
   (`dpkg`, `pacman`, `zypper`, ...) to print what `pacapt` will do.
   Use `PACAPT_DEBUG=auto` for auto-detection.
6. You can use `docker` for testing, by mounting the `pacapt.dev` script
   to the container. See also `docker.i` section in `Makefile`. Example:

````
$ make pacapt.dev
$ docker run --rm -ti \
    -v $PWD/pacapt.dev:/usr/bin/pacman \
    debian:stable /bin/bash
# you are in container now
````

## Generating `pacapt` script

6. The `pacapt` script is generated from the latest stable branch,
   it is there to make installation process simple.
7. Please **do not** use `make pacapt` to update `pacapt`,
   and/or modify it manually.
8. For your development, use `make pacapt.dev`

## Branches

2. `ng`:
    The current development branch.
    Some pull requests are merged on to this branch,
    but the work may not be ready for production.
3. `v2.0`:
    The current stable branch.
    All future `v2.x` releases come from this branch.

5. `your feature branch`:
    For new feature or bug fix, please work on your own branch
    and create pull request.
    Do not put different ideas on a same branch
    because that makes future tracking harder.

## Closed branches

1. `master`:
    The old stable code of the `pacapt`.
    This branch is closed on May 4th, 2014.
