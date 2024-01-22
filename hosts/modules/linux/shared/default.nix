{
  config,
  pkgs,
  lib,
  currentSystem,
  naturalMouseScrolling,
  ...
}: let
  inherit (lib) mkOptionDefault;
in {
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
