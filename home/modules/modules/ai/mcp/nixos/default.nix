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

      ai.agents.github-copilot-cli.settings.mcpServers.nixos = {
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
  };
}
