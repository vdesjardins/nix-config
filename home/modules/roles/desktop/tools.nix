{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption types optionals;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.desktop.tools;
in {
  options.roles.desktop.tools = {
    enable = mkEnableOption "desktop tools (diagnostic, graphics)";
    diagnostic.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable diagnostic tools (mission-center)";
    };
    graphics.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable graphics tools (gimp, inkscape, krita)";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs;
      (optionals cfg.diagnostic.enable [mission-center])
      ++ (optionals cfg.graphics.enable [
        gimp
        inkscape
        krita
      ]);
  };
}
