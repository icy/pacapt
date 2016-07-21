TESTS = *.txt

default:
	@grep -E "^# [a-z].+: .+" Makefile

# gen: Generating `pacapt.dev`
tmp/pacapt.dev::
	@( cd ../ && make -s pacapt.dev ; )
	@cp -u ../pacapt.dev tmp/
	@chmod 755 $(@)

# all: Execute all test scripts
# all: To execute a subset of tests, list them with TESTS=...
# all: for example, `make all TESTS="foo.txt bar.txt"
all: tmp/pacapt.dev
	@./test.sh $(TESTS)

# clean: Remove all temporary files under /tmp/
# clean: (but still keep all log files.)
clean:
	@rm -fv tmp/*.sh tmp/pacapt.dev
	@echo Please remove tmp/*.log manually.
