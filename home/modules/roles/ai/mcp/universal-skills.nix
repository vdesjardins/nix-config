{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ai.mcp.universal-skills;
in {
  options.roles.ai.mcp.universal-skills = {
    enable = mkEnableOption "universal-skills";
  };

  config = mkIf cfg.enable {
    modules.mcp.universal-skills.enable = true;
  };
}
