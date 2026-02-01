{
  pkgs,
  config,
  ...
}: let
  inherit (config.networking) hostName;
in {
  services.alloy = {
    enable = true;

    configPath = ./config;

    extraFlags = [
      "--server.http.listen-addr=127.0.0.1:12346"
      "--disable-reporting"
    ];
  };

  services.geoipupdate = {
    enable = true;

    settings = {
      AccountID = 1108497;
      LicenseKey = "/var/services/geoipupdate/license-key";
      EditionIDs = ["GeoLite2-City" "GeoLite2-Country"];
    };
  };

  system.activationScripts.secrets-alloy.text =
    # bash
    ''
      mkdir -p /var/services/geoipupdate
      chmod 700 /var/services/geoipupdate

      ${pkgs.passage}/bin/passage hosts/${hostName}/geoip/license > /var/services/geoipupdate/license-key
    '';
}
