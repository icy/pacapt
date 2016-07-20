default:
	@grep -E "^# [a-z].+: .+" Makefile

# gen: Generating `pacapt.dev`
tmp/pacapt.dev::
	@( cd ../ && make -s pacapt.dev ; )
	@cp -u ../pacapt.dev tmp/
	@chmod 755 $(@)

all: tmp/pacapt.dev
	@./test.sh *.txt

# clean: Remove all temporary files under /tmp/
# clean: (but still keep all log files.)
clean:
	@rm -fv tmp/*.sh tmp/pacapt.dev
