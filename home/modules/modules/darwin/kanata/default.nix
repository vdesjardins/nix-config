{
  pkgs,
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) str;

  cfg = config.modules.darwin.kanata;
in {
  options.modules.darwin.kanata = {
    enable = mkEnableOption "kanata";
    font = mkOption {
      type = str;
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.kanata-with-cmd ];

    xdg.configFile."kanata/kanata.kbd".source = ./kanata.kbd;
  };
}
