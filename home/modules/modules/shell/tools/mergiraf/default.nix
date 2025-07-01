{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.mergiraf;
in {
  options.modules.shell.tools.mergiraf = {
    enable = mkEnableOption "mergiraf merge tool";
  };

  config = mkIf cfg.enable {
    programs = {
      mergiraf = {
        inherit (cfg) enable;
      };
    };
  };
}
