{ config, lib, pkgs, inputs, ... }: {
  imports = [
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
}
