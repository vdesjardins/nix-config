{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.fd;
in {
  options.modules.shell.tools.fd = {
    enable = mkEnableOption "fd";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [fd];
    xdg.configFile."fd/ignore".source =
      ./ignore;
  };
}
