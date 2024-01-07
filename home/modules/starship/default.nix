{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = mkIf config.programs.starship.enable {
    programs.starship = {
      package = pkgs.unstable.starship;
    };

    xdg.configFile."starship.toml".source = ./starship.toml;
  };
}
