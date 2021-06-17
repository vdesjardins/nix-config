
{config, lib, pkgs, inputs, ...}: {
  home-manager.useGlobalPkgs = true;
  home-manager.users.vdesjardins = { pkgs, ... }: {
    home.sessionVariables = {
	NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM = 1;
    };

    home.sessionVariables = {
	VAULT_USERNAME = "inf10906";
	VAULT_ADDR = "https://vault.gcp.internal";
    };

    imports = [
      inputs.vde-neovim.hmModule

      ./default.nix
     
      ../role/utils
      ../role/dev/nix
      ../role/dev/yaml
      ../role/dev/json
      ../role/dev/bash
      ../role/security
      ../program/alacritty
      ../program/karabiner
      ../service/gpg-agent
      ../program/ssh
      ../program/gcloud
    ];
   };
  }
