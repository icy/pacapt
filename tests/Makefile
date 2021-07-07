TESTS = *.txt
IMAGES =

.PHONY: default
default:
	@grep -E "^# [a-z].+:" Makefile

# gen:
# gen: Generating `pacapt.dev`
tmp/pacapt.dev::
	@( cd ../ && make -s pacapt.dev ; )
	@mkdir -p ./tmp/
	@cp -u ../pacapt.dev tmp/
	@chmod 755 $(@)

# all:
# all: Execute all test scripts
# all: To execute a subset of tests, list them with TESTS=...
# all: for example, `make all TESTS="foo.txt bar.txt"
.PHONY: all
all: tmp/pacapt.dev
	@IMAGES=$(IMAGES) ./test.sh $(TESTS)

# gen:
# gen: Generate test scripts but don't execute them
.PHONY: gen
gen: tmp/pacapt.dev
	@TESTS_DO_NOT_RUN=1 ./test.sh *.txt

# clean:
# clean: Remove all temporary files under /tmp/
# clean: (but still keep all log files.)
.PHONY: clean
clean:
	@rm -fv tmp/*.sh tmp/pacapt.dev
	@echo Please remove tmp/*.log manually.

# test_homebrew:
# test_homebrew: Execute tests within MacOS provided by Github-actions
.PHONY: test_homebrew
test_homebrew:
	@set -u && echo $$CI >/dev/null
	@mkdir -pv tmp
	@ruby -n ../bin/gen_tests.rb < homebrew.txt > tmp/homebrew.sh
	@cd tmp && MSG_PREFIX=":: [homebrew] " sh homebrew.sh

# test_pkgng:
# test_pkgng: Execute FreeBSD tests within MacOS provided by Github-actions
.PHONY: test_pkgng
test_pkgng:
	@set -u && echo $$CI >/dev/null
	@mkdir -pv tmp
	@ruby -n ../bin/gen_tests.rb < pkgng.txt > tmp/pkgng.sh
	@pkg remove -y bash || true
	@cd tmp && MSG_PREFIX=":: [pkgng] " sh pkgng.sh
