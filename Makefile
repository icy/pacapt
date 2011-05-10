default:
	@echo "make README: Build the README file from script's contents"

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
