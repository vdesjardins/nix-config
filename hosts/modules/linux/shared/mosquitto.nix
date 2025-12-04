{pkgs, ...}: let
  configFile = pkgs.writeTextFile {
    name = "mosquitto.conf";
    text = ''
      allow_anonymous false
      listener 1883
      listener 9001
      protocol websockets
      persistence true
      password_file /mosquitto/config/pwfile
      persistence_file mosquitto.db
      persistence_location /mosquitto/data/
    '';
  };
  pwFile = pkgs.writeTextFile {
    name = "pwfile";
    text = ''root:$7$101$zFNC3JK96d5Y8DEe$cI/W8fSKBuzMolomvbQTqcbGdP0mnpHPDBiXKUkfe6Xa9gO/lSyTry2jO/9LCI9CMsKMUqY4eKU48l9mXlWvzg=='';
  };
in {
  virtualisation.oci-containers.containers.mosquitto = {
    # renovate: datasource=docker depName=docker.io/eclipse-mosquitto
    image = "docker.io/eclipse-mosquitto:2.0.22";

    ports = [
      "1883:1883"
      "9001:9001"
    ];
    volumes = [
      "${configFile}:/mosquitto/config/mosquitto.conf"
      "${pwFile}:/mosquitto/config/pwfile"
    ];
  };
}
