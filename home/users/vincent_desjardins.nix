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
    ../role/utils
    ../program/vault
    ../role/dev/yaml
    ../role/dev/json
    ../role/dev/cpp
    ../role/dev/rust
    ../role/dev/make
    ../role/dev/terraform
    ../role/dev/vimscript
    ../role/dev/nix
    ../role/dev/bash
    ../role/dev/lua
    ../role/dev/go
    ../role/dev/rust
    ../role/dev/debugging
    ../role/ops/container
    ../role/ops/gcloud
    ../role/ops/aws
    ../role/ops/k8s
    ../role/ops/networking
  ];
}
