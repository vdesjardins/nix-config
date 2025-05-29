{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.dev.zig;
in {
  options.roles.dev.zig = {
    enable = mkEnableOption "dev.zig";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [zig];
  };
}
