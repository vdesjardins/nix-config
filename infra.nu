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
	--compute-hash = false
] {
	glob $pattern | each { |file|
		let package_data = (open $file)

		let owner = ($package_data | get owner?)
		let repo = ($package_data | get repo?)
		let revision = ($package_data | get revision?)
		let version = ($package_data | get version?)
		let locked = ($package_data | default false locked | get locked)
		let ref = ($package_data | get ref?)
		let fetch_method = ($package_data | get fetch_method? | default "url")

		let token = passage apis/github/vince/default

		if ($owner == null or $repo == null or $revision == null or $locked) {
			print $"Skipping ($file): Missing owner, repo, revision or locked"
			return
		}

		if ($ref != null) {
			print $"Processing ($file) by ref"
			update_by_ref $token $file $package_data $owner $repo $revision $ref $compute_hash $fetch_method
		} else {
			print $"Processing ($file) by version"
			update_by_version $token $file $package_data $owner $repo $revision $version $compute_hash $fetch_method
		}
	}
}

def fetch_dep [
	file: string
	revision: string
	owner: string
	repo: string
	fetch_method: string
] {
	let result = if ($fetch_method == "git") {
		print $"Fetching git revision ($revision) for ($file)"
		let url = $"git@github.com:($owner)/($repo)"
		(nix-prefetch-git --url $url --rev $revision --fetch-submodules --quiet | jq '.hash' -Mr | xargs nix hash convert --to sri --hash-algo sha256 | complete)
	} else {
		print $"Fetching archive revision ($revision) for ($file)"
		let url = $"https://github.com/($owner)/($repo)/archive/($revision).tar.gz"
		(nix-prefetch-url --unpack $url --type sha256 | xargs nix hash convert --to sri --hash-algo sha256 | complete)
	}

	if ($result.exit_code != 0) {
		make error {
			msg: $"Fetch failed for ($file): ($result)"
		}
	}

	{
		hash: ($result.stdout | str trim)
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
	compute_hash
	fetch_method
] {
	let latest = http get --headers ["Authorization" $"Bearer ($token)"] $"https://api.github.com/repos/($owner)/($repo)/releases/latest" | get tag_name

	if ($revision == $latest) {
		if ($compute_hash == false) {
			print $"Skipping ($file): Revision is up to date"
			return
		}
	}

	print $"Updating ($file)"

	let fetch_rev = fetch_dep $file $latest $owner $repo $fetch_method

	let $package_data = $package_data | merge {
		revision: $latest
		version: ($latest | str replace "v" "")
		hash: $fetch_rev.hash
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
	compute_hash
	fetch_method
] {
	let commit = http get --headers ["Authorization" $"Bearer ($token)"] $"https://api.github.com/repos/($owner)/($repo)/commits" | first | get sha

	if $commit == $revision {
		if ($compute_hash == false) {
			print $"Skipping ($file): Revision is up to date"
			return
		}
	}

	print $"Updating ($file)"

	let fetch_rev = fetch_dep $file $commit $owner $repo $fetch_method

	let version = date now | format date "%Y-%m-%d"

	let $package_data = $package_data | merge {
		version: $version
		revision: $commit
		hash: $fetch_rev.hash
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
