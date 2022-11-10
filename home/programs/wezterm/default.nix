{ config, lib, pkgs, ... }:
let
  wezterm_config = import ./wezterm-tmux.nix { inherit (config.home) homeDirectory; };
  pkg_wezterm = pkgs.unstable.wezterm;
in
lib.mkMerge [
  {
    home.packages = [ pkg_wezterm ];
    xdg.configFile."wezterm/wezterm.lua".text = wezterm_config;

    programs.zsh = {
      initExtra = ''
        source ${pkg_wezterm}/etc/profile.d/wezterm.sh
      '';
    };
  }
  (lib.mkIf pkgs.stdenv.isDarwin
    {
      # home-manager do not yet symlink to ~/Applications
      # https://github.com/nix-community/home-manager/issues/1341
      home.file."Applications/WezTerm.app".source =
        "${pkg_wezterm}/Applications/WezTerm.app";
    })
]
