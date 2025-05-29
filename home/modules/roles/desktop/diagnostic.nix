{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.desktop.diagnostic;
in {
  options.roles.desktop.diagnostic = {
    enable = mkEnableOption "desktop.diagnostic";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [mission-center];
  };
}
