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
      command = getExe cfg.package;
      args = ["mcp"];
    };
  };
}
