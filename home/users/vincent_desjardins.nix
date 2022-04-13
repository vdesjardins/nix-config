{ pkgs, ... }:
{
  nixpkgs = pkgs;

  home.sessionVariables = {
    EDITOR = "vi";
    VAULT_USERNAME = "inf10906";
    VAULT_ADDR = "https://vault.gcp.internal";
  };

  xdg.enable = true;

  imports = [
    ../program/vault
    ../role/dev/bash
    ../role/dev/cpp
    ../role/dev/cue
    ../role/dev/debugging
    ../role/dev/go
    ../role/dev/json
    ../role/dev/lua
    ../role/dev/make
    ../role/dev/nix
    ../role/dev/rust
    ../role/dev/rust
    ../role/dev/terraform
    ../role/dev/vimscript
    ../role/dev/yaml
    ../role/ops/aws
    ../role/ops/container
    ../role/ops/gcloud
    ../role/ops/k8s
    ../role/ops/networking
    ../role/utils
  ];
}
