{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ai.mcp.fluxcd;
in {
  options.roles.ai.mcp.fluxcd = {
    enable = mkEnableOption "fluxcd";
  };

  config = mkIf cfg.enable {
    modules.mcp.fluxcd.enable = true;
  };
}
