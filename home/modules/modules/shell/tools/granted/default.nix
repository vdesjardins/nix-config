{
  config,
  inputs,
  lib,
  pkgs,
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

    modules.desktop.browsers.firefox.extensions = with inputs.nur.legacyPackages.${pkgs.stdenv.hostPlatform.system}.repos.rycee.firefox-addons; [
      {package = granted;}
    ];
  };
}
