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
    modules = {
      desktop.editors.nixvim.ai.mcpServers.desktop-commander = {
        command = getExe cfg.package;
      };

      mcp.utcp-code-mode.mcpServers.desktop-commander = {
        transport = "stdio";
        command = getExe cfg.package;
      };

      shell.tools.github-copilot-cli.settings.mcpServers.desktop-commander = {
        type = "local";
        command = getExe cfg.package;
        tools = ["*"];
        args = [];
      };
    };

    programs.opencode.settings.mcp."desktop-commander" = {
      enabled = false;
      type = "local";
      command = [(getExe cfg.package)];
    };
  };
}
