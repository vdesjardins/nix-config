{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ai.mcp.github;
in {
  options.roles.ai.mcp.github = {
    enable = mkEnableOption "github";
  };

  config = mkIf cfg.enable {
    modules.mcp.github.enable = true;
  };
}
