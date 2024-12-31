{pkgs, ...}: {
  services.tailscale.enable = true;

  environment.systemPackages = with pkgs; [
    tailscale
  ];

  # required to get the user and group davfs2 it seems.
  # used for taildrive.
  services.davfs2.enable = true;
}
