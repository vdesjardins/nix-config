{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.dev.lua;
in {
  options.roles.dev.lua = {
    enable = mkEnableOption "dev.lua";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      lua5_3
    ];
  };
}
