{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf getExe;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) package;

  cfg = config.modules.shell.tools.rbw;
in {
  options.modules.shell.tools.rbw = {
    enable = mkEnableOption "rbw";
    pinentryPackage = mkOption {
      type = package;
      default = pkgs.pinentry-gnome3;
    };
  };

  config = mkIf cfg.enable {
    programs.rbw = {
      inherit (cfg) enable;

      settings = {
        email = "vdesjardins@gmail.com";
        pinentry = cfg.pinentryPackage;
      };
    };
  };
}
