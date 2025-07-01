{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ai.mcp.context7;
in {
  options.roles.ai.mcp.context7 = {
    enable = mkEnableOption "context7";
  };

  config = mkIf cfg.enable {
    modules.mcp.context7.enable = true;
  };
}
