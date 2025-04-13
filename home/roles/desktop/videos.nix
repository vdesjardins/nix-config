{pkgs, ...}: {
  modules.desktop.video.obs-studio.enable = true;
  home.packages = with pkgs; [vlc];
}
