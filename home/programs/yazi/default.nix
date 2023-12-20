{pkgs, ...}: {
  programs.yazi = {
    enable = true;

    enableZshIntegration = true;
    package = pkgs.unstable.yazi;
  };

  home.packages = with pkgs; [
    ffmpegthumbnailer
    poppler # pdf
    unar
  ];
}
