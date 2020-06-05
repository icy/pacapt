BINDIR=/usr/local/bin/
DISTRO=debian:stable

default:
	@echo "This is an experimental Makefile. Use it at your own risk."
	@echo ""
	@echo "  pacapt.dev  : Generate development script."
	@echo '  install.dev : Install development script into $$BINDIR.'
	@echo "  pacapt      : Generate stable script."
	@echo '  install     : Install stable script into $$BINDIR.'
	@echo "  clean       : (Experimental) Remove git-ignored files."
	@echo "  shellcheck  : Syntax and style checking. Use http://shellcheck.net/."
	@echo "  docker.i    : Launch interactive Docker container which mounts."
	@echo '                your local 'pacapt.dev' script to $$BINDIR/pacman.'
	@echo '                Please use DISTRO= to specify Docker image'
	@echo "  tests       : Run all tests. Please read tests/README.md first."
	@echo "                Use TESTS= to specify a package. Docker is required."
	@echo "  stats       : Generate table of implemented operations in development branch."
	@echo "  update_stats: Update README.md using results from 'stats' section."
	@echo ""
	@echo "Environments:"
	@echo ""
	@echo "  VERSION     : Version information. Default: git commit hash."
	@echo "  BINDIR      : Destination directory. Default: /usr/local/bin."
	@echo "  DISTRO      : Container image. Default: debian:stable."

# Build and install development script

pacapt.dev: ./lib/*.sh ./lib/*.txt bin/compile.sh
	@./bin/compile.sh > $(@) || { rm -fv $(@); exit 1; }
	@bash -n $(@)
	@chmod 755 $(@)
	@echo 1>&2 "The output file is '$(@)' (unstable version)"

.PHONY: install.dev
install.dev: pacapt.dev
	@if [ -e $(@) ] && ! file $(@) | grep -q 'script'; then \
		echo >&2 "Makefile Will not overwrite non-script $(@)"; \
		exit 1; \
	else \
		install -vm755 pacapt.dev $(BINDIR)/pacapt; \
	fi

# Build and install stable script

.PHONY: pacapt.check

pacapt.check:
	@test -n "${VERSION}" || { echo ":: Please specify VERSION, i.e., make pacapt VERSION=1.2.3"; exit 1; }

pacapt: pacapt.check ./lib/*.sh ./lib/*.txt bin/compile.sh
	@./bin/compile.sh > $(@).tmp || { rm -fv $(@).tmp; exit 1; }
	@mv -fv $(@).tmp $(@)
	@bash -n $(@)
	@chmod 755 $(@)
	@echo 1>&2 "The output file is '$(@)' (stable version)"

.PHONY: install
install: $(BINDIR)/pacapt

$(BINDIR)/pacman:
	@if [ ! -e $(@) ]; then \
		ln -vs $(BINDIR)/pacapt $(@); \
	fi

$(BINDIR)/pacapt: pacapt
	@if [ -e $(@) ] && ! file $(@) | grep -q 'script'; then \
		echo >&2 "Makefile Will not overwrite non-script $(@)"; \
		exit 1; \
	else \
		install -vm755 pacapt $(BINDIR)/pacapt; \
	fi

.PHONY: docker.i
docker.i:
	@docker run --rm -ti \
    -v $(PWD)/pacapt.dev:$(BINDIR)/pacman \
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
	@cd tests/ && make -s clean

.PHONY: shellcheck
shellcheck:
	@./bin/check.sh _check_files bin/*.sh lib/*.sh

.PHONY: tests
tests:
	@cd tests/ && make all
