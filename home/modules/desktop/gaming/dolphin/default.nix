{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.desktop.gaming.dolphin;
in {
  options.modules.desktop.gaming.dolphin = {
    enable = mkEnableOption "dolphin";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [dolphinEmuMaster];

    wayland.windowManager.sway.config.assigns."5" = [
      {app_id = "^org.dolphin-emu.$";}
      {class = "^dolphin-emu$";}
    ];
  };
}
