{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.dev.js;
in {
  options.roles.dev.js = {
    enable = mkEnableOption "dev.js";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nodePackages.node2nix
    ];
  };
}
