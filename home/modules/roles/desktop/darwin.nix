{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.desktop.darwin;
in {
  options.roles.desktop.darwin = {
    enable = mkEnableOption "desktop.darwin";
  };

  config = mkIf cfg.enable {
    modules.darwin = {
      aerospace.enable = true;
      karabiner.enable = true;
    };
  };
}
