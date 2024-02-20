{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.desktop.browsers.tridactyl;
in {
  options.modules.desktop.browsers.tridactyl = {
    enable = mkEnableOption "tridactyl";
  };

  config = mkIf cfg.enable {
    modules.desktop.browsers.firefox.extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      {
        package = tridactyl;
        nativeMessagingHost = pkgs.tridactyl-native;
      }
    ];
  };
}
