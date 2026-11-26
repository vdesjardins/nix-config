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
		"mcp-proxy",
		"pi-tokyo-night-storm", "skill-creator",
		"tinted-jjui", "tmux-mcp", "vimPlugins-markdown-toc-nvim",
		"officecli-skills", "parallel-agent-skills", "pi-telegram", "pi-files-widget",
		"pi-markdown-preview", "skill-jj", "skill-tmux", "skill-reviewer",
		"mcp-server-git", "ketall", "writing-skills",
		"git-mcp",
		"opencode-notifier",
		"vimPlugins-kcl", "vimPlugins-codecompanion-history",
		"vimPlugins-blink-emoji", "vimPlugins-blink-copilot",
		"vimPlugins-blink-cmp-dictionary", "vimPlugins-noice-nvim",
		"vimPlugins-blink-cmp-yanky"]

    let flake_path = pwd
	let pkgs_to_update = if ($packages | length) > 0 {
		$packages
	} else {
		nix eval --impure --expr $"
		let
		  inherit \(builtins\) getFlake;
		  currentSystem = builtins.currentSystem;
		  flake = getFlake \"($flake_path)\";
		in
		builtins.toJSON \(builtins.attrNames \(flake.lib.flattenAttrs' flake.outputs.packages.${currentSystem}\)\)" --raw | from json
	}

	# Local-source packages do not have upstream releases.
	let skipped = ["kubectl-helpers", "vmBuilderImage", "sec-skills-audit", "skill-flux", "skill-timewarrior-efficient-entry"]
	let results = $pkgs_to_update | where { |package| $package not-in $skipped } | each { |package|
		print $"Updating package: ($package)"
        try {
          let output = if $package == "playwright-mcp" {
              nix-update --flake --generate-lockfile $package --version-regex '^v([0-9.]+)$'
          } else if $package == "openshell" {
              nix-update --flake --generate-lockfile $package --use-github-releases
          } else if $package in $pkgs_latest {
              nix-update --flake --generate-lockfile $package --version=branch
          } else {
              nix-update --flake --generate-lockfile $package
          }
          print $output
          {package: $package, success: true}
        } catch { |err|
          print -e $"Failed to update ($package): ($err.msg)"
          {package: $package, success: false}
        }
	}
	let failed = $results | where success == false | get package
	if ($failed | is-not-empty) {
		error make {msg: $"Package updates failed: ($failed | str join ', ')"}
	}
}

def main [] {}
