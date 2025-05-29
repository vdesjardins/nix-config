{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.vaults;
in {
  options.roles.vaults = {
    enable = mkEnableOption "vaults";
  };

  config = mkIf cfg.enable {
    modules.shell.tools = {
      passage.enable = true;
      rbw.enable = true;
    };
  };
}
