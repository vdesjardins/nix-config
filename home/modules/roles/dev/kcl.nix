{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.dev.kcl;
in {
  options.roles.dev.kcl = {
    enable = mkEnableOption "dev.kcl";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      kcl
      kcl-language-server
    ];
  };
}
