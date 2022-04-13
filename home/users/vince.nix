{ config, pkgs, ... }: {
  home-manager.useGlobalPkgs = true;

  home-manager.sharedModules = [ ../modules ];

  home-manager.users.vince = { ... }: {
    home.sessionVariables = {
      EDITOR = "vi";
    };

    imports = [
      ./default.nix

      ../program/alacritty
      ../program/karabiner
      ../program/ssh
      ../program/wezterm
      ../role/dev/bash
      ../role/dev/cue
      ../role/dev/debugging
      ../role/dev/go
      ../role/dev/js
      ../role/dev/json
      ../role/dev/lua
      ../role/dev/nix
      ../role/dev/rust
      ../role/dev/yaml
      ../role/ops/aws
      ../role/ops/container
      ../role/ops/k8s
      ../role/ops/networking
      ../role/utils
      ../service/gpg-agent
    ];
  };
}
