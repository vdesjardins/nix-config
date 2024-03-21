{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;

  cfg = config.modules.desktop.tools.obsidian;
in {
  options.modules.desktop.tools.obsidian = {
    enable = mkEnableOption "obsidian";
    font = mkOption {
      type = str;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [obsidian];
  };
}
