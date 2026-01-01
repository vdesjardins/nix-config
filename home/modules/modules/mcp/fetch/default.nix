{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.mcp.fetch;
in {
  options.modules.mcp.fetch = {
    enable = mkEnableOption "fetch mcp server";

    package = mkPackageOption my-packages "mcp-server-fetch" {};
  };

  config = mkIf cfg.enable {
    modules = {
      desktop.editors.nixvim.ai.mcpServers.fetch = {
        command = getExe cfg.package;
      };

      mcp.utcp-code-mode.mcpServers.fetch = {
        transport = "stdio";
        command = getExe cfg.package;
      };

      shell.tools.github-copilot-cli.settings.mcpServers.fetch = {
        type = "local";
        command = getExe cfg.package;
        tools = ["*"];
        args = [];
      };
    };

    programs.opencode.settings.mcp.fetch = {
      enabled = false;
      type = "local";
      command = [(getExe cfg.package)];
    };

    programs.codex.settings.mcp_servers.fetch = {
      enabled = false;
      command = getExe cfg.package;
    };
  };
}
