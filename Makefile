default:
	@echo "make README: Build the README file from script's contents"

README: pacman
	@cat pacman \
		| awk > $(@) \
			' \
				BEGIN { EOF = 0 } \
				{ \
					if ( $$0 ~ /EOF/ ) { EOF += 1 } \
					if ( EOF == 1 ) { print $$0 } \
				} \
			'
