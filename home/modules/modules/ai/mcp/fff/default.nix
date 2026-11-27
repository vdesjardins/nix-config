{
  config,
  inputs,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf getExe';
  inherit (lib.types) package;

  cfg = config.modules.ai.mcp.fff;
  fffMcpBin = getExe' cfg.package "fff-mcp";
in {
  options.modules.ai.mcp.fff = {
    enable = mkEnableOption "fff mcp server";

    package = mkOption {
      type = package;
      default = inputs.fff.packages.${pkgs.stdenv.hostPlatform.system}.fff-mcp;
      description = "The fff-mcp package to use.";
    };
  };

  config = mkIf cfg.enable {
    modules = {
      desktop.editors.nixvim.ai.mcpServers.fff = {
        command = fffMcpBin;
      };

      ai.agents = {
        antigravity.mcpServers.fff = {
          command = fffMcpBin;
          args = [];
          disabled = false;
        };

        codex.mcpServers.fff = {
          command = fffMcpBin;
          args = [];
          enabled = true;
        };

        claude-code.mcpServers.fff = {
          type = "stdio";
          command = fffMcpBin;
          args = [];
          enabled = true;
        };

        github-copilot-cli.settings.mcpServers.fff = {
          type = "local";
          command = fffMcpBin;
          tools = ["*"];
          args = [];
        };

        kiro.settings.mcpServers.fff = {
          command = fffMcpBin;
          args = [];
          disabled = false;
        };

        pi.mcpServers.fff = {
          command = fffMcpBin;
          args = [];
          # Pi uses the native @ff-labs/pi-fff extension instead of the MCP server.
          enabled = false;
        };
      };
    };

    programs.opencode.settings.mcp.fff = {
      enabled = true;
      type = "local";
      command = [fffMcpBin];
    };
  };
}
