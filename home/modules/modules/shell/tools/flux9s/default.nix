{
  config,
  lib,
  my-packages,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.flux9s;
in {
  options.modules.shell.tools.flux9s = {
    enable = mkEnableOption "flux9s";
  };

  config = mkIf cfg.enable {
    home.packages = [my-packages.flux9s];
  };
}
