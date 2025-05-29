{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.dev.make;
in {
  options.roles.dev.make = {
    enable = mkEnableOption "dev.make";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [checkmake];
  };
}
