{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.dev.yamllint;
in {
  options.modules.dev.yamllint = {
    enable = mkEnableOption "yamllint";
  };

  config = mkIf cfg.enable {
    xdg.configFile."yamllint/config".source = ./config.yaml;
  };
}
