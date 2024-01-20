{
  config,
  pkgs,
  lib,
  stdenv,
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
      package = pkgs.unstable.yazi;
    };

    home.packages = with pkgs; [
      ffmpegthumbnailer
      poppler # pdf
      unar
    ];
  };
}
