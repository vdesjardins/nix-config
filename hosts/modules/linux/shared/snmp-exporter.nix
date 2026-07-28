{pkgs, ...}: let
  auths = {
    trendnet_switch_v2 = {community = "PUBLIC";};
    omada_eap_v2 = {community = "public-0123456789";};
  };

  defaultSnmpConfig = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/prometheus/snmp_exporter/1242b20f9e2050f4d3011818ad3cd0f9d195b78e/snmp.yml";
    sha256 = "sha256-4mfQYSmLH/WAw4M30XZt4P6AkWEIYoN8VU6Hz958yUc=";
  };

  omadaSystemModule = {
    walk = [
      "1.3.6.1.4.1.2021.4.5"
      "1.3.6.1.4.1.2021.4.6"
      "1.3.6.1.4.1.2021.4.14"
      "1.3.6.1.4.1.2021.4.15"
      "1.3.6.1.4.1.2021.10.1.5"
      "1.3.6.1.4.1.2021.11.7"
      "1.3.6.1.4.1.2021.11.8"
      "1.3.6.1.4.1.2021.11.9"
      "1.3.6.1.4.1.2021.11.10"
      "1.3.6.1.4.1.2021.11.11"
    ];
    metrics = [
      {
        name = "omadaMemoryTotalKiB";
        oid = "1.3.6.1.4.1.2021.4.5";
        type = "gauge";
        help = "Total physical memory in KiB reported by the ER707-M2.";
      }
      {
        name = "omadaMemoryAvailableKiB";
        oid = "1.3.6.1.4.1.2021.4.6";
        type = "gauge";
        help = "Available physical memory in KiB reported by the ER707-M2.";
      }
      {
        name = "omadaMemoryBufferKiB";
        oid = "1.3.6.1.4.1.2021.4.14";
        type = "gauge";
        help = "Buffered memory in KiB reported by the ER707-M2.";
      }
      {
        name = "omadaMemoryCachedKiB";
        oid = "1.3.6.1.4.1.2021.4.15";
        type = "gauge";
        help = "Cached memory in KiB reported by the ER707-M2.";
      }
      {
        name = "omadaLoadAverage";
        oid = "1.3.6.1.4.1.2021.10.1.5";
        type = "gauge";
        help = "Load average multiplied by 100 for the 1, 5, and 15 minute intervals.";
        indexes = [
          {
            labelname = "loadIndex";
            type = "gauge";
          }
        ];
      }
      {
        name = "omadaInterruptsPerSecond";
        oid = "1.3.6.1.4.1.2021.11.7";
        type = "gauge";
        help = "Current hardware interrupts per second.";
      }
      {
        name = "omadaContextSwitchesPerSecond";
        oid = "1.3.6.1.4.1.2021.11.8";
        type = "gauge";
        help = "Current context switches per second.";
      }
      {
        name = "omadaCpuUserPercent";
        oid = "1.3.6.1.4.1.2021.11.9";
        type = "gauge";
        help = "CPU time spent in user space as a percentage.";
      }
      {
        name = "omadaCpuSystemPercent";
        oid = "1.3.6.1.4.1.2021.11.10";
        type = "gauge";
        help = "CPU time spent in the kernel as a percentage.";
      }
      {
        name = "omadaCpuIdlePercent";
        oid = "1.3.6.1.4.1.2021.11.11";
        type = "gauge";
        help = "Idle CPU time as a percentage.";
      }
    ];
  };

  generatedConfig = {
    inherit auths;
    modules.omada_system = omadaSystemModule;
  };
  generatedConfigJson = builtins.toJSON generatedConfig;

  snmpConfig = pkgs.runCommand "snmp-config" {} ''
    ${pkgs.yq-go}/bin/yq eval \
      '. * ${generatedConfigJson}' \
      ${defaultSnmpConfig} > $out
  '';
in {
  services.prometheus.exporters.snmp = {
    enable = true;
    configurationPath = snmpConfig;
  };
}
