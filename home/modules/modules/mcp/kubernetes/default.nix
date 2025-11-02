{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.mcp.kubernetes;
in {
  options.modules.mcp.kubernetes = {
    enable = mkEnableOption "kubernetes mcp server";

    package = mkPackageOption my-packages "mcp-server-kubernetes" {};
  };

  config = mkIf cfg.enable {
    modules.desktop.editors.nixvim.ai.mcpServers.kubernetes = {
      command = getExe cfg.package;
    };
    programs.opencode.settings.mcp.kubernetes = {
      enabled = true;
      type = "local";
      command = [(getExe cfg.package)];
    };
  };
}
