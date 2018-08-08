BINDIR=/usr/local/bin/
DISTRO=debian:stable
DEBUG=1
DC=ldc2
DOCKER=docker run --rm -ti -e DFLAGS="-static" -v `pwd`:/src dlanguage/ldc

ifeq ($(VERSION),)
	OUTPUT = pacapt.dev
else
	OUTPUT = pacapt
endif

default:
	@echo "This is an experimental Makefile. Use it at your own risk."
	@echo ""
	@echo '  install     : Install script into $$BINDIR.'
	@echo "  pacapt      : Generate stable script."
	@echo "  clean       : (Experimental) Remove git-ignored files."
	@echo "  shellcheck  : Syntax and style checking. Use http://shellcheck.net/."
	@echo "  docker.i    : Launch interactive Docker container which mounts."
	@echo '                your local 'pacapt[.dev]' script to $$BINDIR/pacman.'
	@echo '                Please use DISTRO= to specify Docker image'
	@echo "  tests       : Run all tests. Please read tests/README.md first."
	@echo "                Use TESTS= to specify a package. Docker is required."
	@echo "  stats       : Generate table of implemented operations in development branch."
	@echo "  update_stats: Update README.md using results from 'stats' section."
	@echo ""
	@echo "  dtest       : Testing D programs. Output written to output/."
	@echo "  dbuild      : Build D programs. Output written to output/."
	@echo ""
	@echo "Environments:"
	@echo ""
	@echo "  VERSION     : Version information. Default: git commit hash."
	@echo "                (If specified, the stable script is generated.)"
	@echo "  BINDIR      : Destination directory. Default: /usr/local/bin."
	@echo "  DISTRO      : Container image. Default: debian:stable."

# Build and install development script

.PHONY: install.dev
install.dev:
	@VERSION= make $(BINDIR)/pacapt

.PHONY: pacapt.check
pacapt.check:
	@test -n "${VERSION}" \
		|| echo ":: Please specify VERSION to make stable version."
	@echo ":: Your pacapt output is: $(OUTPUT)"

pacapt.dev: pacapt
pacapt: pacapt.check ./lib/*.sh ./lib/*.txt bin/compile.sh
	@./bin/compile.sh > $(OUTPUT).tmp || { rm -fv $(OUTPUT).tmp; exit 1; }
	@mv -fv $(OUTPUT).tmp $(OUTPUT)
	@bash -n $(OUTPUT)
	@chmod 755 $(OUTPUT)
	@echo 1>&2 "The output file is '$(OUTPUT)'."

.PHONY: install
install: $(BINDIR)/pacapt

$(BINDIR)/pacman:
	@if [ ! -e $(@) ]; then \
		ln -vs $(BINDIR)/pacapt $(@); \
	fi

$(BINDIR)/pacapt: $(OUTPUT)
	@if [ -e $(@) ] && ! file $(@) | grep -q 'script'; then \
		echo >&2 "Makefile Will not overwrite non-script $(@)"; \
		exit 1; \
	else \
		install -vm755 $(OUTPUT) $(BINDIR)/pacapt; \
	fi

.PHONY: docker.i
docker.i:
	@docker run --rm -ti \
    -v $(PWD)/$(OUTPUT):$(BINDIR)/pacman \
    $(DISTRO) /bin/bash

.PHONY: update_stats
update_stats:
	@./bin/update_stats.sh

.PHONY: stats
stats:
	@./bin/gen_stats.sh

.PHONY: clean
clean:
	@if git clean -nX | grep -q .; then \
		git clean -nX; \
		echo -n "Remove these files? [y/N] "; \
		read ANS; \
		case "$$ANS" in \
			[yY]*) git clean -fX ;; \
			*) exit 1;; \
		esac ; \
	fi
	@rm -fv output/* || true;
	@cd tests/ && make -s clean

.PHONY: shellcheck
shellcheck:
	@./bin/check.sh _check_files bin/*.sh lib/*.sh

output/pacapt.libs:: $(OUTPUT)
	@mkdir -pv output/
	@PACAPT_LIBS_ONLY=yes ./bin/compile.sh > $(@)

output/pacapt_passthrough.libs: lib/*.sh
	@mkdir -pv output/
	@./bin/compile_passthrough.sh > $(@)

.PHONY: dtest
dtest: output/pacapt.libs output/pacapt_passthrough.libs
	@mkdir -pv output/
	@$(DOCKER) dub test --compiler=$(DC) --debug="$(DEBUG)" pacapt:main

.PHONY: dbuild
dbuild: output/pacapt.libs output/pacapt_passthrough.libs
	@mkdir -pv output/
	@$(DOCKER) dub build --compiler=$(DC) --debug="0" pacapt:main

.PHONY: tests
tests: dtest
	@cd tests/ && make all
