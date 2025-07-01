{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;
  inherit (config.modules.home) configDirectory;
  inherit (config.lib.file) mkOutOfStoreSymlink;

  cfg = config.modules.shell.tools.ssh;
in {
  options.modules.shell.tools.ssh = {
    enable = mkEnableOption "secure shell";
  };

  config = mkIf cfg.enable {
    programs.ssh = {
      inherit (cfg) enable;

      controlMaster = "auto";
      controlPersist = "30s";

      extraOptionOverrides = {
        Include = "local/*_config";
      };

      userKnownHostsFile =
        builtins.toString (mkOutOfStoreSymlink "${configDirectory}/shell/tools/ssh/config/known_hosts");
    };
  };
}
