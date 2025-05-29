{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.dev.go;
in {
  options.roles.dev.go = {
    enable = mkEnableOption "dev.go";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      delve
      go
      gopls
      gokart
    ];
  };
}
