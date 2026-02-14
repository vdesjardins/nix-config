{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.ai.mcp.tree-sitter;
in {
  options.modules.ai.mcp.tree-sitter = {
    enable = mkEnableOption "tree-sitter mcp server";

    package = mkPackageOption my-packages "mcp-server-tree-sitter" {};
  };

  config = mkIf cfg.enable {
    modules = {
      desktop.editors.nixvim.ai.mcpServers.tree_sitter = {
        command = getExe cfg.package;
      };

      ai.agents.github-copilot-cli.settings.mcpServers.tree_sitter = {
        type = "local";
        command = getExe cfg.package;
        tools = ["*"];
        args = [];
      };
    };

    programs.opencode.settings.mcp.tree_sitter = {
      enabled = true;
      type = "local";
      command = [(getExe cfg.package)];
    };
  };
}
