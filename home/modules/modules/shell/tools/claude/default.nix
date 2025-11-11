{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.claude;
in {
  options.modules.shell.tools.claude = {
    enable = mkEnableOption "claude";
  };

  config = mkIf cfg.enable {
    programs.claude-code = {
      enable = true;
    };
  };
}
