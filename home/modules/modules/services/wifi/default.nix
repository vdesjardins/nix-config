{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf getExe;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.services.wifi;
in {
  options.modules.services.wifi = {
    enable = mkEnableOption "wifi";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [iwgtk];

    programs.waybar.settings.mainBar.network.on-click = getExe pkgs.iwgtk;

    wayland.windowManager.sway.config = {
      window.commands = [
        {
          criteria = {
            app_id = "^org.twosheds.iwgtk$";
          };
          command = "floating enable, sticky enable, border pixel 1";
        }
      ];
    };
  };
}
