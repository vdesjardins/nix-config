{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;
  inherit (config.lib.file) mkOutOfStoreSymlink;
  inherit (config.modules.home) configDirectory;

  cfg = config.modules.shell.tools.k9s;
in {
  options.modules.shell.tools.k9s = {
    enable = mkEnableOption "k9s cli";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [k9s];

    xdg.configFile = {
      "k9s/skins/tokyonight.yaml".source = ./config/skin-tokyonight.yaml;
      "k9s/config.yaml".source = mkOutOfStoreSymlink "${configDirectory}/shell/tools/k9s/config/config.yaml";
      "k9s/views.yaml".source = mkOutOfStoreSymlink "${configDirectory}/shell/tools/k9s/config/views.yaml";
      "k9s/plugins".source = ./config/plugins;
    };
  };
}
