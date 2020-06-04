TESTS = *.txt

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
	@./test.sh $(TESTS)

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
