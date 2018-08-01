TESTS = *.txt

.PHONY: default
default:
	@grep -E "^# [a-z].+:" Makefile

# gen:
# gen: Generating `pacapt`
tmp/pacapt::
	@( cd ../ && VERSION= DEBUG=2 make -s dbuild; )
	@mkdir -p ./tmp/
	@cp -u ../output/pacapt tmp/
	@chmod 755 $(@)

# all:
# all: Execute all test scripts
# all: To execute a subset of tests, list them with TESTS=...
# all: for example, `make all TESTS="foo.txt bar.txt"
.PHONY: all
all: tmp/pacapt
	@./test.sh $(TESTS)

# gen:
# gen: Generate test scripts but don't execute them
.PHONY: gen
gen: tmp/pacapt
	@TESTS_DO_NOT_RUN=1 ./test.sh *.txt

# clean:
# clean: Remove all temporary files under /tmp/
# clean: (but still keep all log files.)
.PHONY: clean
clean:
	@rm -fv tmp/*.sh tmp/pacapt
	@echo Please remove tmp/*.log manually.
