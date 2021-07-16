{ config, lib, pkgs, ... }: {
  programs.alacritty = { enable = true; };

  xdg.configFile."alacritty/alacritty.yml".source = ./alacritty.yml;

  # home-manager do not yet symlink to ~/Applications
  # https://github.com/nix-community/home-manager/issues/1341
  home.file."Applications/Alacritty.app".source =
    lib.mkIf pkgs.stdenv.hostPlatform.isDarwin
      "${pkgs.alacritty}/Applications/Alacritty.app";
}
