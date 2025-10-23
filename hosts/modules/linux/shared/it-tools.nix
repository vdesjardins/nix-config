{...}: {
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
        image = "ghcr.io/corentinth/it-tools:latest";

        ports = [
          "9000:80"
        ];
      };
    };
  };
}
