BINDIR=/usr/local/bin/

default:
	@echo "This is an experimental Makefile. Use it at your own risk."
	@echo ""
	@echo "  pacapt.dev  : generate development script"
	@echo "  install.dev : install development script into '$(BINDIR)'"
	@echo "  pacapt      : generate stable script"
	@echo "  install     : install stable script into '$(BINDIR)'"
	@echo "  clean       : (experimental) remove git-ignored files"
	@echo ""
	@echo "The VERSION environment is to provide version information."
	@echo "If VERSION isn't set, the last git commit hash will be used."

# Build and install development script

pacapt.dev: ./lib/*.sh compile.sh
	@./compile.sh > $(@)
	@chmod 755 $(@)
	@echo 1>&2 "The output file is '$(@)' (unstable version)"

install.dev: pacapt.dev
	@if [ -e $(@) ] && ! file $(@) | grep -q 'shell script'; then \
		echo >&2 "Makefile Will not overwrite non-script $(@)"; \
		exit 1; \
	else \
		install -m755 $(<) $(BINDIR)/pacapt; \
	fi

# Build and install stable script

pacapt: ./lib/*.sh compile.sh
	@./compile.sh > $(@)
	@chmod 755 $(@)
	@echo 1>&2 "The output file is '$(@)' (stable version)"

install: $(BINDIR)/pacapt

$(BINDIR)/pacapt: pacapt
	@if [ -e $(@) ] && ! file $(@) | grep -q 'shell script'; then \
		echo >&2 "Makefile Will not overwrite non-script $(@)"; \
		exit 1; \
	else \
		install -m755 $(<) $(BINDIR)/pacapt; \
	fi

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
