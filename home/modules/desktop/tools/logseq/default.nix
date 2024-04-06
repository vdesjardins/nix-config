{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;

  cfg = config.modules.desktop.tools.logseq;
in {
  options.modules.desktop.tools.logseq = {
    enable = mkEnableOption "logseq";
    font = mkOption {
      type = str;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [unstable.logseq];
  };
}
