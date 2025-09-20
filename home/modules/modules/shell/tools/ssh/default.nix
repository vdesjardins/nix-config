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

      enableDefaultConfig = false;

      extraOptionOverrides = {
        Include = "local/*_config";
      };

      matchBlocks."*" = {
        controlMaster = "auto";
        controlPersist = "30s";

        userKnownHostsFile =
          builtins.toString (mkOutOfStoreSymlink "${configDirectory}/shell/tools/ssh/config/known_hosts");
      };
    };
  };
}
