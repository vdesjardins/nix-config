{...}: {
  services.nginx = {
    enable = true;

    virtualHosts."opencode.kube-stack.org" = {
      forceSSL = true;
      enableACME = true;
      acmeRoot = null;

      locations."/" = {
        proxyPass = "http://localhost:4096";
        proxyWebsockets = true;
        recommendedProxySettings = true;
      };
    };
  };
}
