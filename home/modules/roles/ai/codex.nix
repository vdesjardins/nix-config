{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ai.codex;
in {
  options.roles.ai.codex = {
    enable = mkEnableOption "codex";
  };

  config = mkIf cfg.enable {
    modules.shell.tools.codex.enable = true;
  };
}
