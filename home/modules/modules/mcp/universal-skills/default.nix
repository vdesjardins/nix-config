{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.mcp.universal-skills;
in {
  options.modules.mcp.universal-skills = {
    enable = mkEnableOption "universal-skills mcp server";

    package = mkPackageOption my-packages "universal-skills" {};
  };

  config = mkIf cfg.enable {
    modules.desktop.editors.nixvim.ai.mcpServers.universal-skills = {
      command = "${getExe cfg.package} mcp";
    };

    programs.opencode.settings.mcp.universal-skills = {
      enabled = true;
      type = "local";
      command = [(getExe cfg.package) "mcp"];
    };

    programs.codex.settings.mcp_servers.universal-skills = {
      enabled = true;
      command = "${getExe cfg.package} mcp";
    };

    modules.shell.tools.github-copilot-cli.settings.mcpServers.universal-skills = {
      type = "local";
      command = "${getExe cfg.package} mcp";
      tools = ["*"];
      args = [];
    };
  };
}
