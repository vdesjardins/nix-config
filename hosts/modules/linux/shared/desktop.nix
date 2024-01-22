{
  config,
  pkgs,
  ...
}: {
  boot = {
    initrd.verbose = false;
    consoleLogLevel = 3;
    kernelParams = [
      "quiet"
      "rd.udev.log_level=3"
    ];
  };

  security = {
    rtkit.enable = true;
    polkit.enable = true;
  };

  hardware.opengl.enable = true;

  services.blueman.enable = config.hardware.bluetooth.enable;

  environment.sessionVariables = {
    TERM = "xterm-256color";
  };

  nix = {
    daemonCPUSchedPolicy = "idle";
    daemonIOSchedClass = "idle";
  };

  security = {
    sudo.wheelNeedsPassword = false;
  };

  fonts = {
    fontDir.enable = true;
  };

  environment.systemPackages = with pkgs; [
    gnumake
    git
    neovim

    (writeShellScriptBin "xrandr-auto" ''
      xrandr --output Virtual-1 --auto
    '')

    gtkmm3

    # VMware on M1 doesn't support automatic resizing yet
    (writeShellScriptBin "xrandr-mbp" ''
      xrandr -s 3840x2160
      xrandr --dpi 120
    '')
  ];

  programs.dconf.enable = true;

  services.pcscd.enable = true;

  networking.firewall.enable = false;

  virtualisation.docker.enable = true;
}
