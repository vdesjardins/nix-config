{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf mkEnableOption;
  cfg = config.modules.desktop.messaging.fluffychat;
in {
  options.modules.desktop.messaging.fluffychat = {
    enable = mkEnableOption "Fluffychat Matrix client";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      fluffychat
    ];
  };
}
