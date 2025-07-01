{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.desktop.browsers.bitwarden;
in {
  options.modules.desktop.browsers.bitwarden = {
    enable = mkEnableOption "bitwarden";
  };

  config = mkIf cfg.enable {
    modules.desktop.browsers.firefox.extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      {
        package = bitwarden;
        area = "navbar";
      }
    ];
  };
}
