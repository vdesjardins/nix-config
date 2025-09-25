{
  config,
  inputs,
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

    modules.desktop.browsers.firefox.extensions = with inputs.nur.legacyPackages.${pkgs.system}.repos.rycee.firefox-addons; [
      {package = granted;}
    ];
  };
}
