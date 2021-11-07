.DEFAULT_GOAL := help
SHELL = /bin/bash

.PHONY: flake-update
flake-update:
	nix flake lock --update-input

.PHONY: vincent_desjardins
## vincent_desjardins: build and activate vincent_desjardins system
vincent_desjardins:
	nix build ./#vincent_desjardins && ./result/activate

.PHONY: work-mac
## work-mac: build and activate work-mac system
work-mac:
	@nix build .#work-mac
	@./result/sw/bin/darwin-rebuild switch --flake .#work-mac

.PHONY: dev-mac
## dev-mac: build and activate dev-mac system
dev-mac:
	@nix build .#dev-mac
	@./result/sw/bin/darwin-rebuild switch --flake .#dev-mac

.PHONY: hm-install
## hm-install: install nix for home-manager
hm-install:
	@sh <(curl -L https://nixos.org/nix/install) --daemon
	@PATH=$PATH:/nix/var/nix/profiles/default/bin nix-env -iA nixpkgs.nixFlakes
	@echo 'experimental-features = nix-command flakes' >> ~/.config/nix/nix.conf"
	@cachix use vdesjardins
	@echo "TODO: need to source /nix/var/nix/profiles/default/etc/profile.d/nix.sh"

.PHONY: darwin-bootstrap
## darwin-bootstrap: bootstrap darmin nix with default configuration
darwin-bootstrap:
	@nix build .#darwinConfigurations.bootstrap.system
	@./result/sw/bin/darwin-rebuild switch --flake .#bootstrap

.PHONY: darwin-install
## darwin-install: install nix darwin
darwin-install:
	@sh <(curl -L https://nixos.org/nix/install) --daemon
	@PATH=$PATH:/nix/var/nix/profiles/default/bin nix-env -iA nixpkgs.nixFlakes
	@sudo sh -c "echo 'experimental-features = nix-command flakes ca-derivations ca-references' >> /etc/nix/nix.conf"
	@echo "TODO: need to source /nix/var/nix/profiles/default/etc/profile.d/nix.sh"

.PHONY: darwin-install-brew
## darwin-install-brew: install brew
darwin-install-brew:
	@/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

.PHONY: help
## help: Prints this help message
help:
	@echo "Usage: \n"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'
