{
  config,
  pkgs,
  lib,
  ...
}: let
  dashLib = import ./lib {inherit pkgs lib;};

  dashboardConfigs = {
    opnsense = {
      id = 22248;
      version = 1;
      sha256 = "sha256:1sy6k1bcprldgnzq8z86c5ilv4pb2yiz0jn7xpma2rcfvpkaw9al";
      transform = dashboard:
        lib.pipe dashboard [
          (dashLib.setUid "opnsense")
          (dashLib.replaceDatasources [
            {
              key = "DS_PROMETHEUS";
              value = "Prometheus";
            }
          ])
          dashLib.removeTimeOverrides
          dashLib.fixProcessesPanel
        ];
    };
    opnsense-ids = {
      path = ./dashboards/opnsense-ids.json;
      transform = dashboard:
        lib.pipe dashboard [
          (dashLib.setUid "opnsense-ids")
        ];
    };
    cadvisor = {
      id = 14282;
      version = 1;
      sha256 = "sha256-dqhaC4r4rXHCJpASt5y3EZXW00g5fhkQM+MgNcgX1c0=";
      transform = dashboard:
        lib.pipe dashboard [
          (dashLib.setUid "cadvisor")
          (dashLib.replaceDatasources [
            {
              key = "DS_PROMETHEUS";
              value = "Prometheus";
            }
          ])
        ];
    };
    victoriametrics = {
      id = 10229;
      version = 46;
      sha256 = "sha256-uRUDxlOcfq5hhl/OeclVuR9boEYveLpDSL/r3sg69qQ=";
      transform = dashboard:
        lib.pipe dashboard [
          (dashLib.setUid "victoriametrics")
          (
            d:
              d
              // {
                templating =
                  d.templating
                  // {
                    list =
                      (builtins.filter (var: var.name == "ds") d.templating.list)
                      ++ [
                        {
                          name = "job";
                          type = "query";
                          datasource = {
                            type = "prometheus";
                            uid = "$ds";
                          };
                          query = "label_values(vm_app_version{version=~\".*\"}, job)";
                          refresh = 1;
                          includeAll = false;
                        }
                      ]
                      ++ (builtins.filter (var: (var.name != "job" && var.name != "ds")) d.templating.list);
                  };
              }
          )
        ];
    };
    victorialogs = {
      id = 22084;
      version = 9;
      sha256 = "sha256-Ka4qzslO/H0S8czjUvCyIW5JAWXm0uObgGb3kqtULs8=";
      transform = dashboard:
        lib.pipe dashboard [
          (dashLib.setUid "victorialogs")
          (dashLib.replaceDatasources [
            {
              key = "DS_PROMETHEUS";
              value = "Prometheus";
            }
          ])
          (
            d:
              d
              // {
                templating =
                  d.templating
                  // {
                    list =
                      (builtins.filter (var: var.name == "ds") d.templating.list)
                      ++ [
                        {
                          name = "job";
                          type = "query";
                          datasource = {
                            type = "prometheus";
                            uid = "$ds";
                          };
                          query = "label_values(vm_app_version{version=~\".*\"}, job)";
                          refresh = 1;
                          includeAll = false;
                        }
                      ]
                      ++ (builtins.filter (var: (var.name != "job" && var.name != "ds")) d.templating.list);
                  };
              }
          )
        ];
    };
  };

  mkDashboardProvider = name: dashCfg: let
    dashboardPath =
      if dashCfg ? id
      then
        dashLib.fetchDashboard {
          inherit name;
          inherit (dashCfg) id version sha256;
        }
      else if dashCfg ? url
      then
        dashLib.fetchDashboardFromUrl {
          inherit name;
          inherit (dashCfg) url sha256;
        }
      else dashCfg.path or (builtins.throw "Dashboard ${name} must have either 'id', 'url', or 'path'");
  in
    dashLib.dashboardEntry {
      inherit name;
      path = dashboardPath;
      inherit (dashCfg) transform;
    };

  dashboardProviders = lib.mapAttrsToList mkDashboardProvider dashboardConfigs;
in {
  services.nginx = {
    enable = true;

    virtualHosts."grafana.kube-stack.org" = {
      forceSSL = true;
      enableACME = true;
      acmeRoot = null;

      locations."/" = {
        proxyPass = "http://127.0.0.1:${toString config.services.grafana.settings.server.http_port}";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };
  };

  services.grafana = {
    enable = true;

    settings = {
      server = {
        domain = "grafana.kube-stack.org";
        http_port = 3000;
        http_addr = "127.0.0.1";
      };
    };

    declarativePlugins = [
      pkgs.grafanaPlugins.victoriametrics-logs-datasource
      pkgs.grafanaPlugins.victoriametrics-metrics-datasource
    ];

    provision = {
      enable = true;

      datasources.settings = {
        datasources = [
          {
            name = "Prometheus";
            type = "prometheus";
            url = "https://metrics.kube-stack.org";
            isDefault = true;
          }
          {
            name = "VictoriaLogs";
            type = "victoriametrics-logs-datasource";
            access = "proxy";
            url = "http://logs.kube-stack.org";
          }
          {
            name = "VictoriaMetrics";
            type = "victoriametrics-metrics-datasource";
            access = "proxy";
            url = "http://metrics.kube-stack.org";
          }
        ];
      };

      dashboards.settings.providers = dashboardProviders;
    };
  };
}
