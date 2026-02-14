{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.ai.mcp.git;
in {
  options.modules.ai.mcp.git = {
    enable = mkEnableOption "git mcp server";

    package = mkPackageOption my-packages "mcp-server-git" {};
  };

  config = mkIf cfg.enable {
    modules = {
      desktop.editors.nixvim.ai.mcpServers.git = {
        command = getExe cfg.package;
      };

      ai.agents.github-copilot-cli.settings.mcpServers.git = {
        type = "local";
        command = getExe cfg.package;
        tools = ["*"];
        args = [];
      };
    };

    programs.opencode.settings.mcp.git = {
      enabled = false;
      type = "local";
      command = [(getExe cfg.package)];
    };
  };
}
