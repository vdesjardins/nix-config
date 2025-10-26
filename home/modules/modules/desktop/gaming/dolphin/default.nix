{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  settingsFormat = pkgs.formats.yaml {};

  cfg = config.modules.desktop.gaming.dolphin;
in {
  options.modules.desktop.gaming.dolphin = {
    enable = mkEnableOption "dolphin";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [dolphin-emu-beta];

    xdg.configFile = {
      "lutris/runners/dolphin.yml".source = settingsFormat.generate "dolphin.yml" {
        dolphin = {
          nogui = true;
          runner_executable = "${pkgs.dolphin-emu-beta}/bin/dolphin-emu";
        };

        system = {
          disable_runtime = true;

          env = {
            QT_AUTO_SCREEN_SCALE_FACTOR = "1";
            QT_QPA_PLATFORM = "xcb";
          };

          prefix_command = "wrap-scale-off";
        };
      };
    };

    wayland.windowManager.sway.config.assigns."5" = [
      {app_id = "^org.dolphin-emu.$";}
      {class = "^dolphin-emu$";}
    ];
  };
}
