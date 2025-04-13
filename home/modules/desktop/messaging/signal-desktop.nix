{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.desktop.messaging.signal-desktop;
in {
  options.modules.desktop.messaging.signal-desktop = {
    enable = mkEnableOption "Signal desktop client";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      signal-desktop-bin
    ];
  };
}
