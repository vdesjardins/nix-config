{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.dev.yaml;
in {
  options.roles.dev.yaml = {
    enable = mkEnableOption "dev.yaml";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      yamllint
    ];

    modules.dev.yamllint.enable = true;
  };
}
