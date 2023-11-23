{
  config,
  lib,
  pkgs,
  ...
}: let
  wezterm_config = import ./wezterm-tmux.nix {inherit (config.home) homeDirectory;};
  pkg_wezterm = pkgs.unstable.wezterm;
in {
  home.packages = [pkg_wezterm];
  xdg.configFile."wezterm/wezterm.lua".text = wezterm_config;

  programs.zsh = {
    initExtra = ''
      source ${pkg_wezterm}/etc/profile.d/wezterm.sh
    '';
  };
}
