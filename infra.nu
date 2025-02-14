#!/usr/bin/env nu

const EXPERIMENTAL_FEATURES = "nix-command flakes ca-derivations"

def "main hm apply" [] {
    main hm generate
	./result/activate
}

# build current user
def "main hm generate" [] {
    let node = (uname | get nodename)
	nix build $"./#homeConfigurations.($env.USER)@($node).activationPackage"
}

.PHONY: host/genrate
## host/genrate: build current system
host/genrate:
	if [[ "$$(uname -o)" == "Darwin" ]] then
		nix run nix-darwin -- build --flake .#$$(uname --nodename)
	else
		sudo nixos-rebuild build --flake .#$$(uname --nodename)
	fi

def main [] {}
