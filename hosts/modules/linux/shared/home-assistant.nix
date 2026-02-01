{
  config,
  pkgs,
  ...
}: let
  inherit (config.networking) hostName;
  frigateComponent = pkgs.fetchFromGitHub {
    owner = "blakeblackshear";
    repo = "frigate-hass-integration";
    tag = "v5.9.4";
    hash = "sha256-LzrIvHJMB6mFAEfKoMIs0wL+xbEjoBIx48pSEcCHmg4=";
  };
  opnsenseComponent = pkgs.fetchFromGitHub {
    owner = "travisghansen";
    repo = "hass-opnsense";
    tag = "v0.4.8";
    hash = "sha256-5oWIFdOcLSul1debsnE34DWqEC1dEXN7vZYR2gLlI7A=";
  };
  advancedCameraCardComponent = pkgs.stdenvNoCC.mkDerivation (finalAttrs: {
    pname = "advanced-camera-card";
    version = "7.3.6";

    src = pkgs.fetchzip {
      url = "https://github.com/dermotduffy/advanced-camera-card/releases/download/v7.19.0/advanced-camera-card.zip";
      hash = "sha256-+sDIs1r3668FrpnJ3qcQlrfDvtapODj5LVOb6yStSA8=";
    };

    dontBuild = true;

    installPhase = ''
      mkdir -p $out/advanced-camera-card
      mv * $out/advanced-camera-card
    '';
  });

  hassConfig = {
    # Loads default set of integrations. Do not remove.
    default_config = {};

    # Load frontend themes from the themes folder
    frontend = {
      themes = "!include_dir_merge_named themes";
    };

    automation = "!include automations.yaml";
    script = "!include scripts.yaml";
    scene = "!include scenes.yaml";

    http = {
      use_x_forwarded_for = true;
      trusted_proxies = "127.0.0.1";
    };

    # lovelace = {
    #   mode = "storage";
    #   resources = [
    #     {
    #       url = "/hassfiles/advanced-camera-card/advanced-camera-card.js";
    #       type = "module";
    #     }
    #   ];
    # };
  };

  configFile = (pkgs.formats.yaml {}).generate "configuration.yaml" hassConfig;
in {
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
    containers = {
      home-assistant = {
        # renovate: datasource=docker depName=home-assistant/home-assistant
        image = "ghcr.io/home-assistant/home-assistant:2026.1.3";

        environment.TZ = config.time.timeZone;

        extraOptions = [
          "--network=host"
          "--cap-add=NET_RAW"
          "--cap-add=NET_ADMIN"
        ];

        volumes = [
          "/run/dbus:/run/dbus:ro"
          "/data/home-assistant/config:/config"
          # "${configFile}:/config/configuration.yaml:ro"
          "${frigateComponent}/custom_components/frigate:/config/custom_components/frigate"
          "${opnsenseComponent}/custom_components/opnsense:/config/custom_components/opnsense"
          "${advancedCameraCardComponent}/advanced-camera-card/:/hassfiles/advanced-camera-card"
        ];
      };
    };
  };

  systemd.timers.restart-home-assistant = {
    timerConfig = {
      Unit = "restart-home-assistant.service";
      OnCalendar = "Mon 02:30";
    };
    wantedBy = ["timers.target"];
  };

  systemd.services.restart-home-assistant = {
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl try-restart podman-home-assistant.service";
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
      AWS_ACCESS_KEY_ID="$(${pkgs.passage}/bin/passage hosts/${hostName}/backups/home-assistant/b2.key-id)"
      AWS_SECRET_ACCESS_KEY="$(${pkgs.passage}/bin/passage hosts/${hostName}/backups/home-assistant/b2.key)"
      RESTIC_PASSWORD="$(${pkgs.passage}/bin/passage hosts/${hostName}/backups/home-assistant/restic)"
      EOF
    '';
}
