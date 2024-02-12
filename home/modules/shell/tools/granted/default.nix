{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.granted;
in {
  options.modules.shell.tools.granted = {
    enable = mkEnableOption "granted";
  };

  config = mkIf cfg.enable {
    programs.granted.enable = true;

    modules.desktop.browsers.firefox.extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      {
        internalUUID = "539ffb7e-a6df-4771-a736-764eea386f67";
        package = granted;
      }
    ];
  };
}
