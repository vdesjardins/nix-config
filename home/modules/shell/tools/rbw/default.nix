{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.rbw;
in {
  options.modules.shell.tools.rbw = {
    enable = mkEnableOption "rbw";
  };

  config = mkIf cfg.enable {
    programs.rbw = {
      inherit (cfg) enable;

      settings = {
        email = "vdesjardins@gmail.com";
      };
    };
  };
}
