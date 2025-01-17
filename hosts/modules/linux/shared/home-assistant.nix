{
  config,
  lib,
  pkgs,
  ...
}: {
  services.caddy = {
    virtualHosts.home-assistant = {
      hostName = "home-assistant.cerberus-pollux.ts.net";

      extraConfig =
        # caddyfile
        ''
           reverse_proxy http://localhost:8123 {
          }
        '';
    };
  };

  networking.firewall.allowedTCPPorts = [8123];

  virtualisation.oci-containers = {
    backend = lib.mkForce "docker";

    containers = {
      home-assistant = {
        image = "ghcr.io/home-assistant/home-assistant:stable";
        volumes = [
          "/data/home-assistant/config:/config"
        ];

        extraOptions = [
          "--network=host"
        ];
        environment.TZ = config.time.timeZone;
      };
    };
  };

  services.restic.backups.home-assistant = {
    initialize = true;
    repository = "rclone:gdrive:/backups/home-assistant";

    user = "root";
    paths = [
      "/data/home-assistant/config/backups"
    ];

    timerConfig = {
      OnCalendar = "01:00";
      RandomizedDelaySec = "1h";
    };

    passwordFile = "/etc/backups/home-assistant/restic-password";
    rcloneConfigFile = "/etc/backups/home-assistant/rclone-config";

    pruneOpts = [
      "--keep-daily 3"
      "--keep-weekly 3"
      "--keep-monthly 3"
    ];
  };
}
