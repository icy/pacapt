BINDIR=/usr/local/bin

default:
	@echo "make README  : build the README file from script's contents"
	@echo "make install : install pacapt script into $(BINDIR)/"
	@echo "make clean   : remove git-ignored files"

README: Makefile pacapt
	@cat pacapt \
		| awk > $(@) \
			' \
				BEGIN { EOF = 0 } \
				{ \
					if ( $$0 ~ /EOF/ ) { EOF += 1 } \
					else if ( EOF == 1 ) { print $$0 } \
				} \
			'

install: $(BINDIR)/pacapt

$(BINDIR)/pacapt: pacapt
	@if [ -e $(@) ] && ! file $(@) | grep -q 'shell script'; then \
		echo "will not overwrite non-script $(@)" >&2; exit 1; \
	else \
		install $(<) $(@); \
	fi

clean:
	@if git clean -nX | grep -q .; then \
		git clean -nX; echo -n "Remove these files? [y/N] "; read ANS; \
		case "$$ANS" in [yY]*) git clean -fX ;; *) exit 1;; esac ; \
	fi
