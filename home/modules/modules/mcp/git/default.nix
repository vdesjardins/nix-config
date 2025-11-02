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
    modules.desktop.editors.nixvim.ai.mcpServers.git = {
      command = getExe cfg.package;
    };
    programs.opencode.settings.mcp.git = {
      enabled = true;
      type = "local";
      command = [(getExe cfg.package)];
    };
  };
}
