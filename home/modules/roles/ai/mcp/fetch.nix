{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ai.mcp.fetch;
in {
  options.roles.ai.mcp.fetch = {
    enable = mkEnableOption "fetch";
  };

  config = mkIf cfg.enable {
    modules.mcp.fetch.enable = true;
  };
}
