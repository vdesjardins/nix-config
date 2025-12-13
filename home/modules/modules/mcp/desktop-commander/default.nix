{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.mcp.desktop-commander;
in {
  options.modules.mcp.desktop-commander = {
    enable = mkEnableOption "desktop-commander mcp server";

    package = mkPackageOption my-packages "desktop-commander-mcp" {};
  };

  config = mkIf cfg.enable {
    modules.desktop.editors.nixvim.ai.mcpServers.desktop-commander = {
      command = getExe cfg.package;
    };
    programs.opencode.settings.mcp."desktop-commander" = {
      enabled = false;
      type = "local";
      command = [(getExe cfg.package)];
    };

    programs.codex.settings.mcp_servers."desktop-commander" = {
      enabled = false;
      command = getExe cfg.package;
    };

    modules.shell.tools.github-copilot-cli.settings.mcpServers.desktop-commander = {
      type = "local";
      command = getExe cfg.package;
      tools = ["*"];
      args = [];
    };
  };
}
