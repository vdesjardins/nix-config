{ config, pkgs, ... }: {
  nixpkgs.config.allowUnfree = true;

  imports = [
    ../role/utils
    ../role/dev/yaml
    ../role/dev/json
    ../role/dev/cpp
    ../role/dev/nix
    ../role/dev/bash
    ../role/dev/golang
    ../role/dev/rust
    ../role/ops/docker
    ../role/ops/gcloud
    ../role/ops/k8s
    ../role/ops/bpf
  ];

  xdg.enable = true;

  home.username = "vince";
  home.homeDirectory = "/home/vince";
}
