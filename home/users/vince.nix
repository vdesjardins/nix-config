{ ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.users.vince = { ... }: {
    imports = [
      ./default.nix

      ../role/utils
      ../role/dev/nix
      ../role/dev/lua
      ../role/dev/yaml
      ../role/dev/js
      ../role/dev/json
      ../role/dev/bash
      ../role/dev/rust
      ../role/dev/golang
      ../role/ops/aws
      ../role/ops/k8s
      ../role/ops/networking
      ../role/ops/container
      ../program/wezterm
      ../program/alacritty
      ../program/karabiner
      ../service/gpg-agent
      ../program/ssh
    ];
  };
}
