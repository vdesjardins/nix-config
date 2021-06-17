inputs: {
  system = "x86_64-linux";
  username = "vincent_desjardins";
  homeDirectory = "/home/vincent_desjardins";

  extraModules = [ inputs.vde-neovim.hmModule ];

  configuration =
    { pkgs, ... }: {
      nixpkgs.overlays = inputs.vde-neovim.overlays ++ [ import ../overlays/tmux.nix inputs ];

      home.sessionVariables = {
        VAULT_USERNAME = "inf10906";
        VAULT_ADDR = "https://vault.gcp.internal";
      };

      xdg.enable = true;

      imports = [
        ./default.nix

        ../role/utils
        ../program/vault
        ../role/dev/yaml
        ../role/dev/json
        ../role/dev/cpp
        ../role/dev/rust
        ../role/dev/terraform
        ../role/dev/vimscript
        ../role/dev/nix
        ../role/dev/bash
        ../role/dev/lua
        ../role/dev/golang
        ../role/dev/rust
        ../role/dev/debugging
        ../role/ops/docker
        ../role/ops/gcloud
        ../role/ops/aws
        ../role/ops/k8s
        ../role/ops/bpf
        ../role/ops/networking
      ];
    };
}
