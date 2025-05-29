{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.desktop.videos;
in {
  options.roles.desktop.videos = {
    enable = mkEnableOption "desktop.videos";
  };

  config = mkIf cfg.enable {
    modules.desktop.video.obs-studio.enable = true;
    home.packages = with pkgs; [vlc];
  };
}
