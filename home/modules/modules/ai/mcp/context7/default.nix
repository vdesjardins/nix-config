{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.ai.mcp.context7;
in {
  options.modules.ai.mcp.context7 = {
    enable = mkEnableOption "context7 mcp server";

    package = mkPackageOption my-packages "context7" {};
  };

  config = mkIf cfg.enable {
    modules = {
      desktop.editors.nixvim.ai.mcpServers.context7 = {
        command = getExe cfg.package;
      };

      shell.tools.github-copilot-cli.settings.mcpServers.context7 = {
        type = "local";
        command = getExe cfg.package;
        tools = ["*"];
        args = [];
      };
    };

    programs.opencode.settings.mcp.context7 = {
      enabled = false;
      type = "local";
      command = [(getExe cfg.package)];
    };
  };
}
