{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ai.mcp.nixos;
in {
  options.roles.ai.mcp.nixos = {
    enable = mkEnableOption "nixos";
  };

  config = mkIf cfg.enable {
    modules.mcp.nixos.enable = true;
  };
}
