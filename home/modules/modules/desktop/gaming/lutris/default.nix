{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;
  inherit (config.modules.home) configDirectory;
  inherit (config.lib.file) mkOutOfStoreSymlink;

  settingsFormat = pkgs.formats.yaml {};

  cfg = config.modules.desktop.gaming.lutris;
in {
  options.modules.desktop.gaming.lutris = {
    enable = mkEnableOption "lutris";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [lutris-free];

    xdg.configFile = {
      "lutris/lutris.conf".source =
        mkOutOfStoreSymlink "${configDirectory}/desktop/gaming/lutris/config/lutris.conf";

      "lutris/games".source =
        mkOutOfStoreSymlink "${configDirectory}/desktop/gaming/lutris/config/games";

      "lutris/runners/linux.yml".source = settingsFormat.generate "linux.yml" {
        linux = {};

        system = {
          disable_runtime = true;
        };
      };

      "lutris/runners/mupen64plus.yml".source = settingsFormat.generate "mupen64plus.yml" {
        mupen64plus = {
          runner_executable = "${pkgs.mupen64plus}/bin/mupen64plus";
        };

        system = {
          disable_runtime = true;
        };
      };

      "lutris/runners/steam.yml".source = settingsFormat.generate "steam.yml" {
        steam = {};

        system = {
          disable_runtime = true;

          gamemode = false;
        };
      };

      "lutris/runners/wine.yml".source = settingsFormat.generate "wine.yml" {
        wine = {};

        system = {
          prefix_command = "wrap-scale-off";
        };
      };
    };

    wayland.windowManager.sway.config.assigns."5" = [
      {app_id = "^lutris$";}
    ];
  };
}
