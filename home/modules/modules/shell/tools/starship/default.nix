{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.starship;
in {
  options.modules.shell.tools.starship = {
    enable = mkEnableOption "starship prompt";
  };

  config = mkIf cfg.enable {
    programs.starship = {
      inherit (cfg) enable;

      enableZshIntegration = true;
      enableNushellIntegration = true;

      package = pkgs.starship;
    };

    xdg.configFile."starship.toml".source = ./starship.toml;
  };
}
