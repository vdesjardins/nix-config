.DEFAULT_GOAL := help

.PHONY: flake-update
flake-update:
	nix flake lock --update-input

.PHONY: vinced
## vinced: build and activate vinced system
vinced:
	nix build ./#vinced && ./result/activate

.PHONY: work-mac
## work-mac: build and activate vinced system
work-mac:
	nix build ./#work-mac && ./result/activate

.PHONY: help
## help: Prints this help message
help:
	@echo "Usage: \n"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'
