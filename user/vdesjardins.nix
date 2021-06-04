{ config, lib, pkgs, inputs, ... }: {
  imports = [
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
}
