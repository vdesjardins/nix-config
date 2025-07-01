{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;

  cfg = config.modules.desktop.tools.imv;
in {
  options.modules.desktop.tools.imv = {
    enable = mkEnableOption "imv";
    font = mkOption {
      type = str;
    };
  };

  config = mkIf cfg.enable {
    programs.imv = {
      inherit (cfg) enable;

      settings = {
        options = {
          overlay_font = cfg.font;
          background = "24283b";
          fullscreen = "true";
          overlay = "false";
        };
      };
    };

    xdg.mimeApps = {
      defaultApplications = {
        "image/*" = "imv-dir.desktop";
        "image/gif" = "imv-dir.desktop";
        "image/jpeg" = "imv-dir.desktop";
        "image/png" = "imv-dir.desktop";
        "image/webp" = "imv-dir.desktop";
        "image/svg" = "imv-dir.desktop";
      };
    };
  };
}
