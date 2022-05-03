{ config, lib, pkgs, ... }:
let
  wezterm_text = builtins.readFile ./wezterm.lua;
  wezterm_config = builtins.replaceStrings [ "@homeDirectory@" ] [ config.home.homeDirectory ] wezterm_text;
  pkg_wezterm = pkgs.master.wezterm;
in
{
  home.packages = [ pkg_wezterm ];
  xdg.configFile."wezterm/wezterm.lua".text = wezterm_config;

  programs.zsh = {
    initExtra = ''
      source ${pkg_wezterm}/etc/profile.d/wezterm.sh
    '';
  };
} // lib.mkIf pkgs.stdenv.isDarwin {
  # home-manager do not yet symlink to ~/Applications
  # https://github.com/nix-community/home-manager/issues/1341
  home.file."Applications/WezTerm.app".source =
    "${pkg_wezterm}/Applications/WezTerm.app";
}
