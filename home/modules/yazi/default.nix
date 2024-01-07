{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  config = mkIf config.programs.yazi.enable {
    programs.yazi = {
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
