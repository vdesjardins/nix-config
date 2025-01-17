{lib, ...}: {
  services.caddy = {
    virtualHosts.home-server = {
      hostName = "home-server.cerberus-pollux.ts.net";

      extraConfig =
        # caddyfile
        ''
           reverse_proxy https://localhost:8043 {
             transport http {
           	  tls_insecure_skip_verify
             }
          }
        '';
    };
  };

  virtualisation.oci-containers = {
    backend = lib.mkForce "docker";
    containers = {
      omada = {
        image = "mbentley/omada-controller:5.15";
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

  services.restic.backups.omada = {
    initialize = true;
    repository = "rclone:gdrive:/backups/omada";

    user = "root";
    paths = [
      "/data/omada/data/autobackup"
    ];

    timerConfig = {
      OnCalendar = "01:00";
      RandomizedDelaySec = "1h";
    };

    passwordFile = "/etc/backups/omada/restic-password";
    rcloneConfigFile = "/etc/backups/omada/rclone-config";

    pruneOpts = [
      "--keep-daily 3"
      "--keep-weekly 3"
      "--keep-monthly 3"
    ];
  };
}
