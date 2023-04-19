{
  config,
  pkgs,
  lib,
  currentSystem,
  naturalMouseScrolling,
  ...
}: {
  hardware.video.hidpi.enable = true;
  hardware.opengl = {enable = true;};

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.useDHCP = false;

  security.sudo.wheelNeedsPassword = false;

  security.rtkit.enable = true;
  security.polkit.enable = true;

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "4096";
    }
  ];

  virtualisation.docker.enable = true;

  i18n.defaultLocale = "en_CA.UTF-8";

  users.mutableUsers = false;

  fonts = {
    fontDir.enable = true;
  };

  environment.systemPackages = with pkgs; [
    gnumake
    killall
    xclip
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

  environment.sessionVariables = {
    TERM = "xterm-256color";
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    passwordAuthentication = true;
    permitRootLogin = "no";
  };
  networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
