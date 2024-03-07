{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  settingsFormat = pkgs.formats.yaml {};

  cfg = config.modules.desktop.gaming.steam;
in {
  options.modules.desktop.gaming.steam = {
    enable = mkEnableOption "steam";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [steam];

    wayland.windowManager.sway.config.assigns."5" = [
      {class = "^steam$";}
    ];
  };
}
