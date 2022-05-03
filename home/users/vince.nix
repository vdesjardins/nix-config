{ config, pkgs, ... }: {
  home-manager.useGlobalPkgs = true;

  home-manager.sharedModules = [ ../modules ];

  home-manager.users.vince = { ... }: {
    home.sessionVariables = {
      EDITOR = "vi";
    };

    imports = [
      ./default.nix

      ../programs/alacritty
      ../programs/karabiner
      ../programs/ssh
      ../programs/wezterm
      ../roles/dev/bash
      ../roles/dev/cue
      ../roles/dev/debugging
      ../roles/dev/go
      ../roles/dev/js
      ../roles/dev/json
      ../roles/dev/lua
      ../roles/dev/nix
      ../roles/dev/rust
      ../roles/dev/yaml
      ../roles/ops/aws
      ../roles/ops/container
      ../roles/ops/k8s
      ../roles/ops/networking
      ../roles/utils
      ../services/gpg-agent
    ];
  };
}
