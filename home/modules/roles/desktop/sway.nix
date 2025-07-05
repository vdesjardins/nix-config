{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.desktop.sway;

  wallpapersPath = "${config.home.homeDirectory}/Pictures/Wallpapers/";
in {
  options.roles.desktop.sway = {
    enable = mkEnableOption "desktop.sway";
  };

  config = mkIf cfg.enable {
    modules.desktop.window-managers.sway = {
      enable = true;
      inherit wallpapersPath;
    };

    modules.desktop.extensions = {
      swayidle = {
        enable = true;
        inherit wallpapersPath;
      };
    };
  };
}
