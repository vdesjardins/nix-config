{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.modules.shell.tools.yazi;
in {
  options.modules.shell.tools.yazi = {
    enable = mkEnableOption "yazi filebrowser";
  };

  config = mkIf cfg.enable {
    programs.yazi = {
      inherit (cfg) enable;

      enableZshIntegration = true;
      enableNushellIntegration = true;

      package = pkgs.yazi;
    };

    home.packages = with pkgs; [
      ffmpegthumbnailer
      poppler # pdf
      unar
    ];
  };
}
