{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ai.mcp.playright;
in {
  options.roles.ai.mcp.playright = {
    enable = mkEnableOption "playright";
  };

  config = mkIf cfg.enable {
    modules.mcp.playright.enable = true;
  };
}
