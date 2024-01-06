{pkgs, ...}: {
  services.window-manager.sway = {
    enable = true;
  };

  services.cliphist.enable = true;
}
