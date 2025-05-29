{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.dev.json;
in {
  options.roles.dev.json = {
    enable = mkEnableOption "dev.json";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nodePackages.fixjson
      jiq
      jq
      gron
    ];
  };
}
