{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.ncspot;
in {
  options.modules.shell.tools.ncspot = {
    enable = mkEnableOption "ncspot";
  };

  config = mkIf cfg.enable {
    programs.ncspot = {
      inherit (cfg) enable;

      settings = {
        credentials = {
          username_cmd = "echo vdesjardins";
          password_cmd = "passage services/spotify";
        };
      };
    };
  };
}
