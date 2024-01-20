{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.k9s;
in {
  options.modules.shell.tools.k9s = {
    enable = mkEnableOption "k9s cli";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [k9s];

    xdg.configFile."k9s/config.yml".source = ./config.yml;
    xdg.configFile."k9s/views.yml".source = ./views.yml;
  };
}
