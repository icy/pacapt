BINDIR=/usr/local/bin/

default:
	@echo "This is an experimental Makefile. Use it at your own risk."
	@echo ""
	@echo "make pacapt  : generate 'pacapt' script"
	@echo "make install : install 'pacapt' script into '$(BINDIR)'"
	@echo "make clean   : (experimental) remove git-ignored files"

pacapt: ./lib/*.sh compile.sh
	@./compile.sh > $(@)
	@chmod 755 $(@)

install: $(BINDIR)/pacapt

$(BINDIR)/pacapt: pacapt
	@if [ -e $(@) ] && ! file $(@) | grep -q 'shell script'; then \
		echo >&2 "Makefile Will not overwrite non-script $(@)"; \
		exit 1; \
	else \
		install -m755 $(<) $(@); \
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
