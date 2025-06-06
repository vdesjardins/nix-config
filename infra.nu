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

# update packages/overlays fixed dependencies
def "main deps update" [
	pattern: string = "**/*.json"
] {
	glob $pattern | each { |file|
		let package_data = (open $file)

		let owner = ($package_data | get owner?)
		let repo = ($package_data | get repo?)
		let revision = ($package_data | get revision?)
		let version = ($package_data | get version?)
		let locked = ($package_data | default false locked | get locked)
		let ref = ($package_data | get ref?)

		let token = passage apis/github/vince/default

		if ($owner == null or $repo == null or $revision == null or $locked) {
			print $"Skipping ($file): Missing owner, repo, revision or locked"
			return
		}

		if ($ref != null) {
			print $"Processing ($file) by ref"
			update_by_ref $token $file $package_data $owner $repo $revision $ref
		} else {
			print $"Processing ($file) by version"
			update_by_version $token $file $package_data $owner $repo $revision $version
		}
	}
}

def update_by_version [
	token
	file
	package_data
	owner
	repo
	revision
	version
] {
	let latest = http get --headers ["Authorization" $"Bearer ($token)"] $"https://api.github.com/repos/($owner)/($repo)/releases/latest" | get tag_name

	if ($revision == $latest) {
		print $"Skipping ($file): Revision is up to date"
		return
	}

	let url = $"https://github.com/($owner)/($repo)/archive/($latest).tar.gz"

	let result = (nurl $url --hash | to text | complete)

	if ($result.exit_code != 0) {
		print $"nurl failed for ($file): ($result)"
		return
	}

	let $package_data = $package_data | merge {
		revision: $latest
		version: ($latest | str replace "v" "")
		hash: $result.stdout
	}
	$package_data | to json | save $file -f

	update_vendor_hash $package_data $file
}

def update_by_ref [
	token
	file
	package_data
	owner
	repo
	revision
	ref
] {
	let commit = http get --headers ["Authorization" $"Bearer ($token)"] $"https://api.github.com/repos/($owner)/($repo)/commits" | first | get sha

	if $commit == $revision {
		print $"Skipping ($file): Revision is up to date"
		return
	}

	let url = $"https://github.com/($owner)/($repo)/archive/($commit).tar.gz"

	let result = (nurl $url --hash | to text | complete)

	if ($result.exit_code != 0) {
		print $"nurl failed for ($file): ($result)"
		return
	}

	let version = date now | format date "%Y-%m-%d"

	let $package_data = $package_data | merge {
		version: $version
		revision: $commit
		hash: $result.stdout
	}
	$package_data | to json | save $file -f

	update_vendor_hash $package_data $file
}

def update_vendor_hash [
    package_data
    file
] {
    let vendorAttr = ($package_data | get vendorAttr?)
    if ($vendorAttr == null) {
        return $package_data
    }
    let packageFile = ($file | str replace --all ".json" ".nix")
    let vendorHashResult = nurl --expr $"\(\(import <nixpkgs> {}).callPackage ($packageFile) {}).($vendorAttr)" | complete

    if ($vendorHashResult.exit_code != 0) {
        error make {
            msg: $"nurl failed for vendor attribute in ($packageFile): ($vendorHashResult)"
        }
    }

    let trimmedHash = ($vendorHashResult.stdout | str trim)
    let updated = ($package_data | merge { vendorHash: $trimmedHash })
    $updated | to json | save $file -f
    return $updated
}

def main [] {}
