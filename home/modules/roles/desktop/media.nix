{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf mkOption types optionals;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.desktop.media;
in {
  options.roles.desktop.media = {
    enable = mkEnableOption "desktop media (videos, viewers)";
    videos.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable video tools (obs-studio, vlc)";
    };
    viewers.enable = mkOption {
      type = types.bool;
      default = true;
      description = "Enable media viewers (zathura, imv)";
    };
  };

  config = mkIf cfg.enable {
    modules = {
      desktop.video.obs-studio.enable = cfg.videos.enable;
      desktop.tools = {
        zathura.enable = cfg.viewers.enable;
        imv.enable = cfg.viewers.enable;
      };
    };

    home.packages = with pkgs; optionals cfg.videos.enable [vlc];
  };
}
