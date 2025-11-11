{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.codex;
in {
  options.modules.shell.tools.codex = {
    enable = mkEnableOption "codex";
  };

  config = mkIf cfg.enable {
    programs.codex = {
      enable = true;
    };
  };
}
