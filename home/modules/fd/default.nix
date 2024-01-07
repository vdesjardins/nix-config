{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.programs.fd;
in {
  options.programs.fd = {
    enable = mkEnableOption "fd";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [fd];
    xdg.configFile."fd/ignore".source =
      ./ignore;
  };
}
