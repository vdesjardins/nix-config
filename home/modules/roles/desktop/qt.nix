{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.desktop.qt;
in {
  options.roles.desktop.qt = {
    enable = mkEnableOption "desktop.qt";
  };

  config = mkIf cfg.enable {
    qt = {
      enable = true;
      platformTheme.name = "gtk3";
    };
  };
}
