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

    # Waybar already reports network status; keep iwgtk available on click
    # without launching its duplicate tray indicator at session startup.
    xdg.configFile."autostart/iwgtk-indicator.desktop".text = ''
      [Desktop Entry]
      Type=Application
      Name=iwgtk
      Hidden=true
    '';

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
