{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.mcp.git;
in {
  options.modules.mcp.git = {
    enable = mkEnableOption "git mcp server";

    package = mkPackageOption my-packages "mcp-server-git" {};
  };

  config = mkIf cfg.enable {
    modules = {
      desktop.editors.nixvim.ai.mcpServers.git = {
        command = getExe cfg.package;
      };

      mcp.utcp-code-mode.mcpServers.git = {
        transport = "stdio";
        command = getExe cfg.package;
      };

      shell.tools.github-copilot-cli.settings.mcpServers.git = {
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
