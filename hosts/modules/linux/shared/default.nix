{
  config,
  pkgs,
  lib,
  currentSystem,
  naturalMouseScrolling,
  ...
}: {
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.useDHCP = false;
  #systemd.network.enable = true;

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "soft";
      item = "nofile";
      value = "4096";
    }
  ];

  i18n.defaultLocale = "en_CA.UTF-8";

  users.mutableUsers = false;

  environment.sessionVariables = {
    TERM = "xterm-256color";
  };

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
    };
  };
}
