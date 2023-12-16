{
  config,
  options,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.imv.custom;
in {
  options.programs.imv.custom = {
    font = mkOption {
      type = types.str;
    };
  };

  config = {
    programs.imv = {
      enable = true;
      settings = {
        options = {
          background = "24283b";
          fullscreen = "true";
          overlay = "false";
          overlay_font = "${cfg.font}:12";
        };
      };
    };
  };
}
