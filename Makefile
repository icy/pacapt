# Do not set this to /usr/bin as it might overwrite real Arch pacman executable
# (or cause install target to fail if it were to overwrite pacman)
BINDIR=/usr/local/bin

default:
	@echo "make README: Build the README file from script's contents"
	@echo "make install: install pacman script into $(BINDIR)/"
	@echo "make clean: remove git-ignored files"

README: Makefile pacman
	@cat pacman \
		| awk > $(@) \
			' \
				BEGIN { EOF = 0 } \
				{ \
					if ( $$0 ~ /EOF/ ) { EOF += 1 } \
					else if ( EOF == 1 ) { print $$0 } \
				} \
			'

install: $(BINDIR)/pacman

$(BINDIR)/pacman: pacman
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
