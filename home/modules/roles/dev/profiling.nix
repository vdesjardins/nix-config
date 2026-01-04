{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.dev.profiling;
in {
  options.roles.dev.profiling = {
    enable = mkEnableOption "profiling tools";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [tracy];
  };
}
