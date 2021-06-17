[![Build Status](https://travis-ci.org/icy/pacapt.svg?branch=ng)](https://travis-ci.org/icy/pacapt)

## Table of contents

See also https://travis-ci.org/icy/pacapt.

1. [Preparing test environment](#preparing-test-environment)
1. [Invoking test scripts](#invoking-test-scripts)
1. [Writing test cases](#writing-test-cases)
1. [Notes](#notes-on-writing-test-cases)

## Preparing test environment

We run `#bash` test scripts inside `Docker` container. We will need
the following things

1. A fast network to download base images from http://hub.docker.com/,
   and to execute `pacman -Sy` command;
1. Our user environment can execute `docker run` command to create
   new container and mount some host volumes;
1. A basic `Ruby` environment to execute `./bin/gen_tests.rb` script.

Basically we execute the following command

    $ cd <pacapt root directory>

    $ mkdir -p tests/tmp/
    $ ruby -n ./bin/gen_tests.rb \
        < tests/dpkg.txt \
        > tests/tmp/test.sh

    $ cd tests/tmp/
    $ docker run --rm \
        -v $PWD/test.sh:/tmp/test.sh \
        -v $PWD/pacapt.dev:/usr/bin/pacman \
        ubuntu:18.04 \
        /tmp/test.sh

This command will return 0 if all tests pass, or return 1 if any test fails.

For more details, please see in `Makefile` and `test.sh`.

## Invoking test scripts

There are `Makefile` and `test.sh` written and tested in an Arch/Ubuntu
machine. It is expected to work in similar environment with `GNU Make`,
`Bash` and `Docker`.

    $ make                # List all sections
    $ make all            # Execute all test scripts
                          # or a subset of tests, as below
    $ make TESTS="foo.txt bar.txt"

This script will create a temporary directory `tests/tmp/` to store
all logs and details. If there is any test script fails, the process
is stopped for investigation.

## Writing test cases

See examples in `tests/dpkg.txt`. Each test case combines of input command
and output regular expressions used by `grep -E`. Input command is started
by `in `, output regexp is started by `ou `. For example,

    in -Sy
    in -Qs htop
    ou ^htop

the test is passed if the following group of commands returns successfully

    pacman -Sy
    pacman -Qs htop | grep -qE '^htop'

If we want to execute some command other than `pacman` script, use `!`
to write our original command. For example,

    in ! echo Y | pacman -S htop
    in ! echo Y | pacman -R htop
    in -Qi htop
    ou ^Status: deinstall

On `Debian`/`Ubuntu` system, this test case is to ensure that the script
can install `htop` package, then remove it. An alternative test is

    echo Y | pacman -S htop
    echo Y | pacman -R htop
    pacman -Qi htop | grep -E '^Status: deinstall'

## Notes on writing test cases

1. To specify a list of container images, use `im image [image]...`;
1. Each test case has its own temporary file to store all output;
1. Multiple uses of `test.in` is possible, and all results are appended
   to test's temporary file. If we want to clear the contents of this output
   please use `in clear`;
1. Multiple uses of `test.ou` is possible; any fail check will increase
   the total number of failed tests;
1. To make sure that test's temporary file is empty, use `ou empty`;
1. Tests are executed by orders provided in the source file. It's better
   to execute `pacman -Sy` to update package manager's database before
   any other tests, and it's also better to test `clean up` features
   (`pacman -Sc`, `pacman -Scc`, ...) at the very end of the source file.
   See `lib/dpkg.sh` for an example;
1. All tests are executed by `#bash` shell.
1. In any input command, `$LOG` (if any) is replaced by the path to
   test's temporary file;
1. It's very easy to trick the test mechanism; it's our duty to make
   the tests as simple as possible.
