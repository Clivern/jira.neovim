NPM ?= npm


help: Makefile
	@echo
	@echo " Choose a command run in Beaver.js:"
	@echo
	@sed -n 's/^##//p' $< | column -t -s ':' |  sed -e 's/^/ /'
	@echo


## build: Build project
.PHONY: build
build:
	$(NPM) run build


## watch: Build & watch project changes
.PHONY: watch
watch:
	$(NPM) run watch


.PHONY: help