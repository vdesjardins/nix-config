{
  config,
  lib,
  pkgs,
  ...
}: {
  services.nginx = {
    enable = true;

    virtualHosts."home-assistant.kube-stack.org" = {
      forceSSL = true;
      enableACME = true;
      acmeRoot = null;

      locations."/" = {
        extraConfig = ''
          proxy_pass http://127.0.0.1:8123;
          proxy_set_header   X-Real-IP $remote_addr;
          proxy_set_header   X-Forwarded-For $proxy_add_x_forwarded_for;
          proxy_set_header   Host $host;
          proxy_http_version 1.1;
          proxy_set_header   Upgrade $http_upgrade;
          proxy_set_header   Connection "upgrade";
          proxy_buffering off;
        '';
      };
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

    repository = "s3:s3.ca-east-006.backblazeb2.com/kube-backups-home-server/backups/home-assistant";

    user = "root";

    paths = [
      "/data/home-assistant/config/backups"
    ];

    timerConfig = {
      OnCalendar = "01:00";
      RandomizedDelaySec = "1h";
    };

    # HACK: abuse options to use passage instead of supplying a password file
    passwordFile = "";

    environmentFile = "/var/backups/home-assistant/env";

    pruneOpts = [
      "--keep-daily 3"
      "--keep-weekly 3"
      "--keep-monthly 3"
    ];
  };

  system.activationScripts.backups-home-server-home-assistant.text =
    # bash
    ''
      mkdir -p /var/backups/home-assistant
      chmod 700 /var/backups/home-assistant

      cat << EOF > /var/backups/home-assistant/env
      AWS_ACCESS_KEY_ID="$(${pkgs.passage}/bin/passage hosts/home-server/backups/home-assistant/b2.key-id)"
      AWS_SECRET_ACCESS_KEY="$(${pkgs.passage}/bin/passage hosts/home-server/backups/home-assistant/b2.key)"
      RESTIC_PASSWORD="$(${pkgs.passage}/bin/passage hosts/home-server/backups/home-assistant/restic)"
      EOF
    '';

  environment.systemPackages = with pkgs; [git age passage];
}
