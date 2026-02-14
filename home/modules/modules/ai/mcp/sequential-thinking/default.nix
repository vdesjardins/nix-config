{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.ai.mcp.sequential-thinking;
in {
  options.modules.ai.mcp.sequential-thinking = {
    enable = mkEnableOption "sequential-thinking mcp server";

    package = mkPackageOption my-packages "mcp-server-sequential-thinking" {};
  };

  config = mkIf cfg.enable {
    modules.desktop.editors.nixvim.ai.mcpServers.sequential-thinking = {
      command = getExe cfg.package;
    };

    programs.opencode.settings.mcp.sequential-thinking = {
      enabled = true;
      type = "local";
      command = [(getExe cfg.package)];
    };

    modules.ai.agents.github-copilot-cli.settings.mcpServers.sequential-thinking = {
      type = "local";
      command = getExe cfg.package;
      tools = ["*"];
      args = [];
    };
  };
}
