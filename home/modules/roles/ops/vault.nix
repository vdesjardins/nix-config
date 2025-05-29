{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ops.vault;
in {
  options.roles.ops.vault = {
    enable = mkEnableOption "ops.vault";
  };

  config = mkIf cfg.enable {
    modules.shell.tools.vault.enable = true;
  };
}
