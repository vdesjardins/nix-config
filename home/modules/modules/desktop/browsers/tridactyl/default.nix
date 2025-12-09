{
  config,
  inputs,
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
    xdg.configFile."tridactyl/tridactylrc".source = ./tridactylrc;

    modules.desktop.browsers.firefox.extensions = with inputs.nur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.repos.rycee.firefox-addons; [
      {
        package = tridactyl;
        nativeMessagingHost = pkgs.tridactyl-native;
      }
    ];
  };
}
