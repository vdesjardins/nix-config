{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.mcp.context7;
in {
  options.modules.mcp.context7 = {
    enable = mkEnableOption "context7 mcp server";

    package = mkPackageOption my-packages "context7" {};
  };

  config = mkIf cfg.enable {
    modules.desktop.editors.nixvim.ai.mcpServers.context7 = {
      command = getExe cfg.package;
    };
    programs.opencode.settings.mcp.context7 = {
      enabled = true;
      type = "local";
      command = [(getExe cfg.package)];
    };
  };
}
