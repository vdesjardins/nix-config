{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.dev.python;
in {
  options.roles.dev.python = {
    enable = mkEnableOption "dev.python";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [poetry];
  };
}
