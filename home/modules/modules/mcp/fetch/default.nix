{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkEnableOption mkPackageOption mkIf getExe;

  cfg = config.modules.mcp.fetch;
in {
  options.modules.mcp.fetch = {
    enable = mkEnableOption "fetch mcp server";

    package = mkPackageOption my-packages "mcp-server-fetch" {};
  };

  config = mkIf cfg.enable {
    modules.desktop.editors.nixvim.ai.mcpServers.fetch = {
      command = getExe cfg.package;
    };

    programs.opencode.settings.mcp.fetch = {
      enabled = true;
      type = "local";
      command = [(getExe cfg.package)];
    };

    programs.codex.settings.mcp_servers.fetch = {
      enabled = true;
      command = getExe cfg.package;
    };
  };
}
