{pkgs, ...}: {
  home.packages = with pkgs; [
    rofi-rbw
  ];
}
