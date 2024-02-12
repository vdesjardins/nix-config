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
        extensionID = "{b5e0e8de-ebfe-4306-9528-bcc18241a490}";
        internalUUID = "539ffb7e-a6df-4771-a736-764eea386f67";
        package = granted;
      }
    ];
  };
}
