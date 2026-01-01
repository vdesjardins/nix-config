{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.mcp.kubernetes;
in {
  options.modules.mcp.kubernetes = {
    enable = mkEnableOption "kubernetes mcp server";

    package = mkPackageOption my-packages "mcp-server-kubernetes" {};
  };

  config = mkIf cfg.enable {
    modules = {
      desktop.editors.nixvim.ai.mcpServers.kubernetes = {
        command = getExe cfg.package;
      };

      mcp.utcp-code-mode.mcpServers.kubernetes = {
        transport = "stdio";
        command = getExe cfg.package;
      };

      shell.tools.github-copilot-cli.settings.mcpServers.kubernetes = {
        type = "local";
        command = getExe cfg.package;
        tools = ["*"];
        args = [];
      };
    };

    programs.opencode.settings.mcp.kubernetes = {
      enabled = false;
      type = "local";
      command = [(getExe cfg.package)];
    };

    programs.codex.settings.mcp_servers.kubernetes = {
      enabled = false;
      command = getExe cfg.package;
    };
  };
}
