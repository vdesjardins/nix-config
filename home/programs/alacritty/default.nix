{ lib, pkgs, ... }: {
  programs.alacritty = { enable = true; };

  xdg.configFile."alacritty/alacritty.yml".source = ./alacritty.yml;

} // lib.mkIf pkgs.stdenv.isDarwin {
  # home-manager do not yet symlink to ~/Applications
  # https://github.com/nix-community/home-manager/issues/1341
  home.file."Applications/Alacritty.app".source =
    "${pkgs.alacritty}/Applications/Alacritty.app";
}
