{ config, lib, pkgs, ... }: {
  home.packages = with pkgs; [ unstable.wezterm ];
  xdg.configFile."wezterm/wezterm.lua".source = ./wezterm.lua;
  # home-manager do not yet symlink to ~/Applications
  # https://github.com/nix-community/home-manager/issues/1341
  home.file."Applications/WezTerm.app".source =
    lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
      "${pkgs.unstable.wezterm}/Applications/WezTerm.app";
}
