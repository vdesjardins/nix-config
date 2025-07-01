{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ai.mcp.kubernetes;
in {
  options.roles.ai.mcp.kubernetes = {
    enable = mkEnableOption "kubernetes";
  };

  config = mkIf cfg.enable {
    modules.mcp.kubernetes.enable = true;
  };
}
