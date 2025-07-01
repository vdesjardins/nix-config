{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ai.mcp.serena;
in {
  options.roles.ai.mcp.serena = {
    enable = mkEnableOption "serena";
  };

  config = mkIf cfg.enable {
    modules.mcp.serena.enable = true;
  };
}
