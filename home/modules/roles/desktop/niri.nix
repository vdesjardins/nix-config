{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.desktop.niri;

  wallpapersPath = "${config.home.homeDirectory}/Pictures/Wallpapers/";
in {
  options.roles.desktop.niri = {
    enable = mkEnableOption "desktop.niri";
  };

  config = mkIf cfg.enable {
    modules.desktop = {
      window-managers.niri = {
        enable = true;
        inherit wallpapersPath;
      };

      tools.fcitx5.enable = true;
    };
  };
}
