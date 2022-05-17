{ pkgs, ... }: {
  nixpkgs = pkgs;

  home.sessionVariables = {
    VAULT_USERNAME = "inf10906";
    VAULT_ADDR = "https://vault.gcp.internal";
  };

  imports = [
    ./common.nix

    ../programs/alacritty
    ../programs/gcloud
    ../programs/karabiner
    ../programs/ssh
    # ../programs/wezterm
    ../roles/dev/bash
    ../roles/dev/json
    ../roles/dev/nix
    ../roles/dev/rust
    ../roles/dev/yaml
    ../roles/utils
    ../services/gpg-agent
  ];
}
