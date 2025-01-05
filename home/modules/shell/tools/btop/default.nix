{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;

  cfg = config.modules.shell.tools.btop;
in {
  options.modules.shell.tools.btop = {
    enable = mkEnableOption "btop";

    color-theme = mkOption {
      type = str;
    };
  };

  config = mkIf cfg.enable {
    programs.btop = {
      enable = true;
      settings = {
        color_theme = cfg.color-theme;
        vim_keys = true;
      };
    };
  };
}
