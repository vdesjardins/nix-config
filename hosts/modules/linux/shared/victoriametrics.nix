{config, ...}: {
  services.nginx = {
    enable = true;

    virtualHosts."metrics.kube-stack.org" = {
      forceSSL = true;
      enableACME = true;
      acmeRoot = null;

      locations."/" = {
        proxyPass = "http://localhost${config.services.victoriametrics.listenAddress}";
      };
    };
  };

  services.victoriametrics = {
    enable = true;

    retentionPeriod = "35d";

    extraOptions = [
      "-loggerLevel=WARN"
      "-selfScrapeInterval=15s"
    ];

    prometheusConfig = {
      scrape_configs = [
        {
          job_name = "opnsense-exporter";
          scrape_interval = "15s";
          static_configs = [
            {
              targets = ["10.0.0.1:9100"];
              labels.type = "network";
            }
          ];
        }
        {
          job_name = "victorialogs";
          scrape_interval = "15s";
          static_configs = [
            {
              targets = ["${config.services.victorialogs.listenAddress}"];
              labels.type = "logging";
            }
          ];
          metric_relabel_configs = [
            {
              source_labels = ["instance"];
              regex = "^${config.services.victorialogs.listenAddress}$";
              target_label = "instance";
              replacement = "falcon";
            }
          ];
        }
        {
          job_name = "cadvisor";
          scrape_interval = "15s";
          static_configs = [
            {
              targets = ["localhost:${builtins.toString config.services.cadvisor.port}"];
              labels.type = "container";
            }
          ];
          metric_relabel_configs = [
            {
              action = "labelmap";
              regex = "^id$";
              replacement = "name";
            }
            {
              source_labels = ["instance"];
              regex = "localhost:${builtins.toString config.services.cadvisor.port}";
              target_label = "instance";
              replacement = "falcon";
            }
          ];
        }
      ];
    };
  };
}
