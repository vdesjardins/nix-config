{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ai.mcp.tree-sitter;
in {
  options.roles.ai.mcp.tree-sitter = {
    enable = mkEnableOption "mcp tree-sitter";
  };

  config = mkIf cfg.enable {
    modules.mcp.tree-sitter.enable = true;
  };
}
