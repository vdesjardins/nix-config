{pkgs, ...}: {
  programs.steam.enable = true;
  environment.variables.STEAMOS = "1";

  networking.firewall = {
    allowedTCPPorts = [27040];
    allowedUDPPortRanges = [
      {
        from = 27031;
        to = 27036;
      }
    ];
  };

  hardware.xpadneo.enable = true;

  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
      };

      custom = {
        start = "${pkgs.libnotify}/bin/notify-send --app-name GameMode 'GameMode started'";
        end = "${pkgs.libnotify}/bin/notify-send --app-name GameMode 'GameMode ended'";
      };
    };
  };

  environment.systemPackages = with pkgs; [gamescope];

  security.pam.loginLimits = [
    {
      domain = "*";
      type = "-";
      item = "nofile";
      value = "524288";
    }
  ];
}
