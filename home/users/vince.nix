{ ... }: {
  home-manager.useGlobalPkgs = true;
  home-manager.users.vince = { ... }: {
    home.sessionVariables = {
      NIXPKGS_ALLOW_UNSUPPORTED_SYSTEM = 1;
    };

    imports = [
      ./default.nix

      ../role/utils
      ../role/dev/nix
      ../role/dev/yaml
      ../role/dev/json
      ../role/dev/bash
      ../role/dev/rust
      # ../role/security
      # TODO: not compiling on latest
      #../program/wezterm
      ../program/alacritty
      ../program/karabiner
      ../service/gpg-agent
      ../program/ssh
    ];
  };
}
