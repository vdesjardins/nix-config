{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  mod = "Mod4";

  cfg = config.modules.desktop.video.obs-studio;
in {
  options.modules.desktop.video.obs-studio = {
    enable = mkEnableOption "obs-studio";
  };

  config = mkIf cfg.enable {
    programs.obs-studio = {
      inherit (cfg) enable;
    };

    home.packages = with pkgs; [obs-cmd];

    wayland.windowManager.sway.config.keybindings = lib.mkOptionDefault {
      "${mod}+Control+r" = "exec --no-startup-id obs-cmd recording start";
      "${mod}+Control+s" = "exec --no-startup-id obs-cmd recording stop";
      "${mod}+Control+t" = "exec --no-startup-id obs-cmd recording toggle-pause";
    };
  };
}
