{pkgs, ...}: let
  auths = {
    trendnet_switch_v2 = {community = "PUBLIC";};
    omada_eap_v2 = {community = "public-0123456789";};
  };

  defaultSnmpConfig = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/prometheus/snmp_exporter/1242b20f9e2050f4d3011818ad3cd0f9d195b78e/snmp.yml";
    sha256 = "sha256-4mfQYSmLH/WAw4M30XZt4P6AkWEIYoN8VU6Hz958yUc=";
  };

  authsJson = builtins.toJSON {inherit auths;};

  snmpConfig = pkgs.runCommand "snmp-config" {} ''
    ${pkgs.yq-go}/bin/yq eval \
      '. * ${authsJson}' \
      ${defaultSnmpConfig} > $out
  '';
in {
  services.prometheus.exporters.snmp = {
    enable = true;
    configurationPath = snmpConfig;
  };
}
