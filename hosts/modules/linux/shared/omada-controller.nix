{
  pkgs,
  ...
}: {
  services.nginx = {
    enable = true;

    virtualHosts."omada.kube-stack.org" = {
      forceSSL = true;
      enableACME = true;
      acmeRoot = null;

      locations."/" = {
        proxyPass = "https://localhost:8043";
      };
    };
  };

  virtualisation.oci-containers = {
    containers = {
      omada = {
        # renovate: datasource=docker depName=mbentley/omada-controller
        image = "mbentley/omada-controller:5";
        volumes = [
          "/data/omada/data:/opt/tplink/EAPController/data"
          "/data/omada/logs:/opt/tplink/EAPController/logs"
        ];

        extraOptions = [
          "--stop-timeout=60"
          "--ulimit=nofile=4096:8192"
        ];

        ports = [
          "8088:8088"
          "8043:8043"
          "8843:8843"
          "27001:27001/udp"
          "29810:29810/udp"
          "29811-29816:29811-29816"
        ];

        environment = {
          MANAGE_HTTP_PORT = "8088";
          MANAGE_HTTPS_PORT = "8043";
          PORTAL_HTTP_PORT = "8088";
          PORTAL_HTTPS_PORT = "8843";
          PGID = "508";
          PORT_ADOPT_V1 = "29812";
          PORT_APP_DISCOVERY = "27001";
          PORT_DISCOVERY = "29810";
          PORT_MANAGER_V1 = "29811";
          PORT_MANAGER_V2 = "29814";
          PORT_TRANSFER_V2 = "29815";
          PORT_RTTY = "29816";
          PORT_UPGRADE_V1 = "29813";
          PUID = "508";
          SHOW_SERVER_LOGS = "true";
          SHOW_MONGODB_LOGS = "false";
          SSL_CERT_NAME = "tls.crt";
          SSL_KEY_NAME = "tls.key";
          TZ = "Etc/UTC";
        };
      };
    };
  };

  systemd.timers.restart-omada = {
    timerConfig = {
      Unit = "restart-omada.service";
      OnCalendar = "Mon 03:00";
    };
    wantedBy = ["timers.target"];
  };

  systemd.services.restart-omada = {
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl try-restart podman-omada.service";
    };
  };

  services.restic.backups.omada = {
    initialize = true;

    repository = "s3:s3.ca-east-006.backblazeb2.com/kube-backups-home-server/backups/omada";

    user = "root";

    paths = [
      "/data/omada/data/autobackup"
    ];

    timerConfig = {
      OnCalendar = "01:00";
      RandomizedDelaySec = "1h";
    };

    # HACK: use passage instead of supplying a password file
    passwordFile = "";

    environmentFile = "/var/backups/omada/env";

    pruneOpts = [
      "--keep-daily 3"
      "--keep-weekly 3"
      "--keep-monthly 3"
    ];
  };

  system.activationScripts.backups-home-server-omada.text =
    # bash
    ''
      mkdir -p /var/backups/omada
      chmod 700 /var/backups/omada

      cat << EOF > /var/backups/omada/env
      AWS_ACCESS_KEY_ID="$(${pkgs.passage}/bin/passage hosts/home-server/backups/omada/b2.key-id)"
      AWS_SECRET_ACCESS_KEY="$(${pkgs.passage}/bin/passage hosts/home-server/backups/omada/b2.key)"
      RESTIC_PASSWORD="$(${pkgs.passage}/bin/passage hosts/home-server/backups/omada/restic)"
      EOF
    '';

  environment.systemPackages = with pkgs; [git age passage];
}
