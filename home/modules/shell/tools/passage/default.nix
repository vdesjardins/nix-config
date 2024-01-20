{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.passage;
in {
  options.modules.shell.tools.passage = {
    enable = mkEnableOption "passage";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      age-plugin-yubikey
      passage # passwords management with age
      rage
    ];

    home.sessionVariables = {
      PASSAGE_AGE = "rage";
    };
  };
}
