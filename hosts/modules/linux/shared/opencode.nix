{pkgs, ...}: let
  credsDir = "/var/services/opencode";
in {
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
        basicAuthFile = "${credsDir}/nginx-htpasswd";
      };
    };
  };

  system.activationScripts.secrets-opencode.text = ''
    export HOME=/root
    mkdir -p ${credsDir}
    chmod 700 ${credsDir}

    # Fetch plain password from passage and create htpasswd entry
    PASSWORD="$(${pkgs.passage}/bin/passage services/admin/opencode/nginx-htpasswd)"
    HASH="$(${pkgs.openssl}/bin/openssl passwd -apr1 "$PASSWORD")"
    echo "admin:$HASH" > ${credsDir}/nginx-htpasswd
    chmod 640 ${credsDir}/nginx-htpasswd
    chown -R nginx:nginx ${credsDir}
  '';
}
