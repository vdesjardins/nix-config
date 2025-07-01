{
  config,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;
  inherit (config.modules.home) configDirectory;
  inherit (config.lib.file) mkOutOfStoreSymlink;

  cfg = config.modules.darwin.karabiner;
in {
  options.modules.darwin.karabiner = {
    enable = mkEnableOption "karabiner";
  };

  config = mkIf cfg.enable {
    xdg.configFile."karabiner/karabiner.json".source =
      mkOutOfStoreSymlink "${configDirectory}/darwin/karabiner/config/karabiner.json";
  };
}
