{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.desktop.messaging.element-desktop;
in {
  options.modules.desktop.messaging.element-desktop = {
    enable = mkEnableOption "Element Desktop Matrix client";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      element-desktop
    ];
  };
}
