.DEFAULT_GOAL := help
SHELL = bash
.ONESHELL:

EXPERIMENTAL_FEATURES = nix-command flakes ca-derivations

.PHONY: flake-update
flake-update:
	nix flake lock --update-input

.PHONY: hm/current
## hm/current: build and activate current user
hm/current:
	nix build ./#$$USER && ./result/activate

.PHONY: hm/vincent_desjardins
## hm/vincent_desjardins: build and activate vincent_desjardins user
hm/vincent_desjardins:
	nix build ./#vincent_desjardins && ./result/activate

.PHONY: hm/vince
## hm/vince: build and activate vince user
hm/vince:
	nix build ./#vince && ./result/activate

.PHONY: hm/vince-mac
## hm/vince-mac: build and activate vince user
hm/vince-mac:
	export NIXPKGS_ALLOW_BROKEN=1
	nix build ./#vince-mac --impure && ./result/activate

.PHONY: hm/inf10906
## hm/inf10906: build and activate inf10906 user
hm/inf10906:
	nix build ./#inf10906 && ./result/activate

.PHONY: config/work-mac
## config/work-mac: build and activate work-mac system
config/work-mac:
	nix build --experimental-features "$(EXPERIMENTAL_FEATURES)" .#work-mac
	./result/sw/bin/darwin-rebuild switch --flake .#work-mac

.PHONY: config/dev-mac
## config/dev-mac: build and activate dev-mac system
config/dev-mac:
	nix build --experimental-features "$(EXPERIMENTAL_FEATURES)" .#dev-mac
	./result/sw/bin/darwin-rebuild switch --flake .#dev-mac

.PHONY: config/bt-mac
## config/bt-mac: build and activate bt-mac system
config/bt-mac:
	nix build --experimental-features "$(EXPERIMENTAL_FEATURES)" .#bt-mac
	./result/sw/bin/darwin-rebuild switch --flake .#bt-mac

.PHONY: config/dev-vm
## config/dev-vm: build and activate dev-vm system
config/dev-vm:
	sudo nixos-rebuild switch --flake .#dev-vm

.PHONY: hm/install
## hm/install: install nix for home-manager
hm/install:
	sh <(curl -L https://nixos.org/nix/install) --daemon
	PATH=$$PATH:/nix/var/nix/profiles/default/bin nix-env -iA nixpkgs.nixFlakes
	cachix use vdesjardins
	@echo "TODO: need to source /nix/var/nix/profiles/default/etc/profile.d/nix.sh"

.PHONY: darwin/bootstrap-x86_64
## darwin/bootstrap-x86_64: bootstrap darmin nix with default configuration
darwin/bootstrap-x86_64:
	nix build --experimental-features "$(EXPERIMENTAL_FEATURES)" .#darwinConfigurations.bootstrap-x86_64.system
	./result/sw/bin/darwin-rebuild switch --flake .#bootstrap-x86_64

.PHONY: darwin/bootstrap-aarch
## darwin/bootstrap-aarch: bootstrap darmin nix with default configuration
darwin/bootstrap-aarch:
	nix build --experimental-features "$(EXPERIMENTAL_FEATURES)" .#darwinConfigurations.bootstrap-aarch.system
	./result/sw/bin/darwin-rebuild switch --flake .#bootstrap-aarch

.PHONY: darwin/install
## darwin/install: install nix darwin
darwin/install:
	sh <(curl -L https://nixos.org/nix/install) --daemon
	PATH=$$PATH:/nix/var/nix/profiles/default/bin nix-env -iA nixpkgs.nixFlakes
	sudo sh -c "echo 'experimental-features = \"$(EXPERIMENTAL_FEATURES)\"' >> /etc/nix/nix.conf"
	echo "TODO: need to source /nix/var/nix/profiles/default/etc/profile.d/nix.sh"

.PHONY: darwin-install-brew
## darwin-install-brew: install brew
darwin-install-brew:
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

.PHONY: docker/vm-builder
## docker/vm-builder: build docker image to build a vm dev instance
docker/vm-builder:
	docker image load < $$(nix build '.#dockerImage/vm-builder' --no-link --json | jq '.[].outputs.out' -Mr)

.PHONY: build/dev-vm
## build/dev-vm: build vmware vm. param output_path, default pwd
build/dev-vm:
	out_path=$$output_path
	if [[ $$out_path == "" ]]; then
		out_path=$$(pwd)
	fi
	vm_builder_image="nix-builder:latest"
	docker run -it --rm -v $$out_path:/output:rw $$vm_builder_image /bin/create-vm 'github:vdesjardins/nix-config/feat-linux-vm#os-images.vmware.dev-vm'

.PHONY: builder/start
## builder/start: start a darwin builder vm https://nixos.org/manual/nixpkgs/stable/#sec-darwin-builder
# To exit, Ctrl-a + c to open qemu prompt and type quit
builder/start:
	nix run 'nixpkgs#darwin.builder'

.PHONY: builder/dev-vm
## builder/dev-vm: build vmware vm directly using a darwin builder
builder/dev-vm:
	nix build ".#os-images.vmware.dev-vm"

.PHONY: help
## help: Prints this help message
help:
	@echo "Usage: \n"
	@sed -n 's/^##//p' ${MAKEFILE_LIST} | column -t -s ':' |  sed -e 's/^/ /'
