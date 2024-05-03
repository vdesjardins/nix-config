{pkgs, ...}: {
  services.spotifyd.enable = true;
  programs.ncspot.enable = true;

  home.packages = with pkgs; [
    spotify-tui
  ];
}
