{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.passage;
in {
  options.programs.passage = {
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
