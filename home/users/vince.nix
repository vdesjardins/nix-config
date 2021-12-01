{ ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.users.vince = { ... }: {
    imports = [
      ./default.nix

      ../role/utils
      ../role/dev/nix
      ../role/dev/lua
      ../role/dev/yaml
      ../role/dev/json
      ../role/dev/bash
      ../role/dev/rust
      ../role/ops/k8s
      ../program/wezterm
      ../program/alacritty
      ../program/karabiner
      ../service/gpg-agent
      ../program/ssh
    ];
  };
}
