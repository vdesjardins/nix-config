{
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.yamllint;
in {
  options.programs.yamllint = {
    enable = mkEnableOption "yamllint";
  };

  config = mkIf cfg.enable {
    xdg.configFile."yamllint/config".source = ./config.yaml;
  };
}
