{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.mcp.nixos;
in {
  options.modules.mcp.nixos = {
    enable = mkEnableOption "nixos mcp server";

    package = mkPackageOption pkgs "mcp-nixos" {};
  };

  config = mkIf cfg.enable {
    modules = {
      desktop.editors.nixvim.ai.mcpServers.nixos = {
        command = getExe cfg.package;
      };

      mcp.utcp-code-mode.mcpServers.nixos = {
        transport = "stdio";
        command = getExe cfg.package;
      };

      shell.tools.github-copilot-cli.settings.mcpServers.nixos = {
        type = "local";
        command = getExe cfg.package;
        tools = ["*"];
        args = [];
      };
    };

    programs.opencode.settings.mcp.nixos = {
      enabled = false;
      type = "local";
      command = [(getExe cfg.package)];
    };

    programs.codex.settings.mcp_servers.nixos = {
      enabled = false;
      command = getExe cfg.package;
    };
  };
}
