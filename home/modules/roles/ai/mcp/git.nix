{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ai.mcp.git;
in {
  options.roles.ai.mcp.git = {
    enable = mkEnableOption "git";
  };

  config = mkIf cfg.enable {
    modules.mcp.git.enable = true;
  };
}
