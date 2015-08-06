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
	@echo ""
	@echo "Environments"
	@echo ""
	@echo "  VERSION     : Version information. Default: git commit hash."
	@echo "  BINDIR      : Destination directory. Default: /usr/local/bin."
	@echo "  DISTRO      : Container image. Default: debian:stable."

# Build and install development script

pacapt.dev: ./lib/*.sh ./lib/*.txt bin/compile.sh
	@./bin/compile.sh > $(@)
	@bash -n $(@)
	@chmod 755 $(@)
	@echo 1>&2 "The output file is '$(@)' (unstable version)"

install.dev: pacapt.dev
	@if [ -e $(@) ] && ! file $(@) | grep -q 'script'; then \
		echo >&2 "Makefile Will not overwrite non-script $(@)"; \
		exit 1; \
	else \
		install -vm755 pacapt.dev $(BINDIR)/pacapt; \
	fi

# Build and install stable script

pacapt: ./lib/*.sh ./lib/*.txt bin/compile.sh
	@./bin/compile.sh > $(@)
	@bash -n $(@)
	@chmod 755 $(@)
	@echo 1>&2 "The output file is '$(@)' (stable version)"

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

docker.i:
	@docker run --rm -ti \
    -v $(PWD)/pacapt.dev:$(BINDIR)/pacman \
    $(DISTRO) /bin/bash

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

shellcheck:

	@for f in bin/*.sh lib/*.sh; do \
			echo >&2 ":: Checking $$f..." ; \
			./bin/check.sh _check_file "$$f"; \
		done
