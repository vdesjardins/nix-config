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
              targets = ["localhost:${toString config.services.cadvisor.port}"];
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
              regex = "localhost:${toString config.services.cadvisor.port}";
              target_label = "instance";
              replacement = "falcon";
            }
          ];
        }
        {
          job_name = "snmp-exporter";
          scrape_interval = "15s";
          static_configs = [
            {
              targets = ["localhost:9116"];
              labels = {
                type = "snmp-exporter";
              };
            }
          ];
        }
        {
          job_name = "snmp";
          scrape_interval = "15s";
          static_configs = [
            {
              targets = ["10.0.0.2"];
              labels = {
                type = "network-switch";
              };
            }
          ];
          metrics_path = "/snmp";
          params = {
            auth = ["trendnet_switch_v2"];
            module = ["if_mib"];
          };
          relabel_configs = [
            {
              source_labels = ["__address__"];
              target_label = "__param_target";
            }
            {
              source_labels = ["__param_target"];
              target_label = "instance";
            }
            {
              target_label = "__address__";
              replacement = "127.0.0.1:9116";
            }
          ];
        }
        {
          job_name = "snmp-eap";
          scrape_interval = "15s";
          static_configs = [
            {
              targets = ["10.0.0.104" "10.0.0.109"];
              labels = {
                type = "network-eap";
              };
            }
          ];
          metrics_path = "/snmp";
          params = {
            auth = ["omada_eap_v2"];
            module = ["if_mib"];
          };
          relabel_configs = [
            {
              source_labels = ["__address__"];
              target_label = "__param_target";
            }
            {
              source_labels = ["__param_target"];
              target_label = "instance";
            }
            {
              target_label = "__address__";
              replacement = "127.0.0.1:9116";
            }
          ];
        }
      ];
    };
  };
}
