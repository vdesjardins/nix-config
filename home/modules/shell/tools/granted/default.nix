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

    programs.firefox.profiles.default.extensions = with pkgs.nur.repos.rycee.firefox-addons; [
      granted
    ];
  };
}
