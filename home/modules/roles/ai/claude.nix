{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ai.claude;
in {
  options.roles.ai.claude = {
    enable = mkEnableOption "claude";
  };

  config = mkIf cfg.enable {
    modules.shell.tools.claude.enable = true;
  };
}
