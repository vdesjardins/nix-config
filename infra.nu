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

# build current system
def "main host generate" [] {
	if (uname | get operating-system) == "Darwin" {
		nix run nix-darwin -- build --flake $".#(uname | get nodename)"
	} else {
		sudo nixos-rebuild build --flake $".#(uname | get nodename)"
	}
}

# update fixed derivations versions
def "main nix-update" [
	...packages: string
] {
	let pkgs_latest = [
		"english-words", "kubectl-aliases", "lscolors", "tinted-fzf",
		"serena",
		"vimPlugins.kcl", "vimPlugins.codecompanion-history",
		"vimPlugins.blink-emoji", "vimPlugins.blink-copilot", "vimPlugins.blink-cmp-dictionary",
		"vimPlugin.noice-nvim "]

	let pkgs_to_update = if ($packages | length) > 0 {
		$packages
	} else {
		nix eval --impure --expr `
		let
		  inherit (builtins) getFlake;
		  currentSystem = builtins.currentSystem;
		  flake = getFlake "/home/vince/projects/nix-config";
		in
		builtins.toJSON (builtins.attrNames (flake.lib.flattenAttrs' flake.outputs.packages.${currentSystem}))` --raw | from json
	}

	$pkgs_to_update | each { |package|
		print $"Updating package: ($package)"
		if $package in $pkgs_latest {
			nix-update --flake --generate-lockfile $package --version=branch
		} else {
			nix-update --flake --generate-lockfile $package
		}
	}
}

def main [] {}
