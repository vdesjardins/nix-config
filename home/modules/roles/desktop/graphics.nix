{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.desktop.graphics;
in {
  options.roles.desktop.graphics = {
    enable = mkEnableOption "desktop.graphics";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gimp
      inkscape
      krita
    ];
  };
}
