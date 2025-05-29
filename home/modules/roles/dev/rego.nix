{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.dev.rego;
in {
  options.roles.dev.rego = {
    enable = mkEnableOption "dev.rego";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      conftest
    ];
  };
}
