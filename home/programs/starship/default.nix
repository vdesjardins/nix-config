{ pkgs, ... }: {
  programs.starship = {
    enable = true;
    package = pkgs.starship;
  };

  xdg.configFile."starship.toml".source = ./starship.toml;
}
