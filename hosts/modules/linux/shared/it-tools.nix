{pkgs, ...}: {
  services.nginx = {
    enable = true;

    virtualHosts."it-tools.kube-stack.org" = {
      forceSSL = true;
      enableACME = true;
      acmeRoot = null;

      locations."/" = {
        proxyPass = "http://localhost:9000";
      };
    };
  };

  virtualisation.oci-containers = {
    containers = {
      it-tools = {
        # renovate: datasource=docker depName=corentinth/it-tools
        image = "ghcr.io/corentinth/it-tools:latest";

        ports = [
          "9000:80"
        ];
      };
    };
  };

  systemd.timers.restart-it-tools = {
    timerConfig = {
      Unit = "restart-it-tools.service";
      OnCalendar = "Mon 02:30";
    };
    wantedBy = ["timers.target"];
  };

  systemd.services.restart-it-tools = {
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemctl try-restart podman-it-tools.service";
    };
  };
}
