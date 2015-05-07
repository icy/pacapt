BINDIR=/usr/local/bin/

default:
	@echo "This is an experimental Makefile. Use it at your own risk."
	@echo ""
	@echo "  pacapt.dev  : Generate development script"
	@echo '  install.dev : Install development script into $$BINDIR'
	@echo "  pacapt      : Generate stable script"
	@echo '  install     : Install stable script into $$BINDIR'
	@echo "  clean       : (Experimental) Remove git-ignored files"
	@echo ""
	@echo "Environments"
	@echo ""
	@echo "  VERSION     : Version informaiton. Default: git commit hash."
	@echo "  BINDIR      : Destination directory. Default: /usr/local/bin."

# Build and install development script

pacapt.dev: ./lib/*.sh compile.sh
	@./compile.sh > $(@)
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

pacapt: ./lib/*.sh compile.sh
	@./compile.sh > $(@)
	@bash -n $(@)
	@chmod 755 $(@)
	@echo 1>&2 "The output file is '$(@)' (stable version)"

install: $(BINDIR)/pacapt

$(BINDIR)/pacapt: pacapt
	@if [ -e $(@) ] && ! file $(@) | grep -q 'script'; then \
		echo >&2 "Makefile Will not overwrite non-script $(@)"; \
		exit 1; \
	else \
		install -vm755 pacapt $(BINDIR)/pacapt; \
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
