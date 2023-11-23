{
  lib,
  pkgs,
  ...
}: {
  programs.alacritty = {enable = true;};

  xdg.configFile."alacritty/alacritty.yml".source = ./alacritty.yml;
}
