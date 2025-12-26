{config, ...}: {
  services.nginx = {
    enable = true;

    virtualHosts."logs.kube-stack.org" = {
      forceSSL = true;
      enableACME = true;
      acmeRoot = null;

      locations."/" = {
        proxyPass = "http://localhost${config.services.victorialogs.listenAddress}";
      };
    };
  };

  services.victorialogs = {
    enable = true;

    extraOptions = [
      "-retentionPeriod=1w"
      "-maxBackfillAge=1h"
    ];
  };
}
