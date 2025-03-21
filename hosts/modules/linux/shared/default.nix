{...}: {
  nix.gc.dates = "weekly";

  security = {
    pam.loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "nofile";
        value = "4096";
      }
    ];

    sudo.wheelNeedsPassword = false;
  };

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
