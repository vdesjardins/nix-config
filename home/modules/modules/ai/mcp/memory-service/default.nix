{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.ai.mcp.memory-service;
in {
  options.modules.ai.mcp.memory-service = {
    enable = mkEnableOption "memory mcp server";

    package = mkPackageOption my-packages "mcp-memory-service" {};
  };

  config = mkIf cfg.enable {
    modules = {
      desktop.editors.nixvim.ai.mcpServers.memory_service = {
        command = getExe cfg.package;
        args = ["server"];
      };

      shell.tools.github-copilot-cli.settings.mcpServers.memory_service = {
        type = "local";
        command = getExe cfg.package;
        tools = ["*"];
        args = ["server"];
      };
    };

    programs.opencode.settings.mcp.memory_service = {
      enabled = true;
      type = "local";
      command = [(getExe cfg.package) "server"];
    };
  };
}
