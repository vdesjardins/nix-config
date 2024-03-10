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

    xdg.configFile."k9s/config.yml".source = mkOutOfStoreSymlink "${configDirectory}/shell/tools/k9s/config/config.yml";
    xdg.configFile."k9s/views.yml".source = mkOutOfStoreSymlink "${configDirectory}/shell/tools/k9s/config/views.yml";
  };
}
