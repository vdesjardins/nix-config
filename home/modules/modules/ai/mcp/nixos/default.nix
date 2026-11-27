{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.ai.mcp.nixos;
in {
  options.modules.ai.mcp.nixos = {
    enable = mkEnableOption "nixos mcp server";

    package = mkPackageOption pkgs "mcp-nixos" {};
  };

  config = mkIf cfg.enable {
    modules = {
      desktop.editors.nixvim.ai.mcpServers.nixos = {
        command = getExe cfg.package;
      };

      ai.agents = {
        antigravity.mcpServers.nixos = {
          command = getExe cfg.package;
          args = [];
          disabled = true;
        };

        codex.mcpServers.nixos = {
          command = getExe cfg.package;
          args = [];
          enabled = false;
        };

        claude-code.mcpServers.nixos = {
          type = "stdio";
          command = getExe cfg.package;
          args = [];
          enabled = false;
        };

        github-copilot-cli.settings.mcpServers.nixos = {
          type = "local";
          command = getExe cfg.package;
          tools = ["*"];
          args = [];
        };

        kiro.settings.mcpServers.nixos = {
          command = getExe cfg.package;
          args = [];
          disabled = true;
        };

        pi.mcpServers.nixos = {
          command = getExe cfg.package;
          args = [];
          enabled = false;
        };
      };
    };

    programs.opencode.settings.mcp.nixos = {
      enabled = false;
      type = "local";
      command = [(getExe cfg.package)];
    };
  };
}
