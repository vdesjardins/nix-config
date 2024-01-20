{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.darwin.karabiner;
in {
  options.modules.darwin.karabiner = {
    enable = mkEnableOption "karabiner";
  };

  config = mkIf cfg.enable {
    xdg.configFile."karabiner/karabiner.json".source = ./karabiner.json;
  };
}
