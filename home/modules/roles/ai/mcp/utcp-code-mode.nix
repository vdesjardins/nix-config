{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ai.mcp.utcp-code-mode;
in {
  options.roles.ai.mcp.utcp-code-mode = {
    enable = mkEnableOption "utcp-code-mode";
  };

  config = mkIf cfg.enable {
    modules.mcp.utcp-code-mode.enable = true;
  };
}
