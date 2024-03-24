{lib, ...}: {
  virtualisation.oci-containers = {
    backend = lib.mkForce "docker";
    containers = {
      omada = {
        image = "mbentley/omada-controller:5.13";
        volumes = [
          "/data/omada/data:/opt/tplink/EAPController/data"
          "/data/omada/logs:/opt/tplink/EAPController/logs"
        ];
        extraOptions = ["--network=host"];
      };
    };
  };
}
