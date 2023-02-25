{pkgs, ...}: {
  programs.starship = {
    enable = true;
    package = pkgs.unstable.starship;
  };

  xdg.configFile."starship.toml".source = ./starship.toml;
}
