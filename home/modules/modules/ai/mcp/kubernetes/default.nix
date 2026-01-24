{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.ai.mcp.kubernetes;
in {
  options.modules.ai.mcp.kubernetes = {
    enable = mkEnableOption "kubernetes mcp server";

    package = mkPackageOption my-packages "mcp-server-kubernetes" {};
  };

  config = mkIf cfg.enable {
    modules = {
      desktop.editors.nixvim.ai.mcpServers.kubernetes = {
        command = getExe cfg.package;
      };

      shell.tools.github-copilot-cli.settings.mcpServers.kubernetes = {
        type = "local";
        command = getExe cfg.package;
        tools = ["*"];
        args = [];
      };
    };

    programs.opencode.settings.mcp.kubernetes = {
      enabled = false;
      type = "local";
      command = [(getExe cfg.package)];
    };
  };
}
