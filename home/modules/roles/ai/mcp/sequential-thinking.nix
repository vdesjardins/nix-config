{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ai.mcp.sequential-thinking;
in {
  options.roles.ai.mcp.sequential-thinking = {
    enable = mkEnableOption "sequential-thinking";
  };

  config = mkIf cfg.enable {
    modules.mcp.sequential-thinking.enable = true;
  };
}
