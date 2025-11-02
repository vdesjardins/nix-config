{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ai.opencode;
in {
  options.roles.ai.opencode = {
    enable = mkEnableOption "opencode";
  };

  config = mkIf cfg.enable {
    modules.shell.tools.opencode.enable = true;
  };
}
