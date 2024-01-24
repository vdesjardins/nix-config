{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.ssh;
in {
  options.modules.shell.tools.ssh = {
    enable = mkEnableOption "secure shell";
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      inherit (cfg) enable;

      controlMaster = "auto";
      hashKnownHosts = false;
      controlPersist = "30s";

      extraOptionOverrides = {
        Include = "local/*_config";
      };
    };
  };
}
