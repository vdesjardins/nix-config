{
  pkgs,
  config,
  ...
}: let
  inherit (config.networking) hostName;
  credsDir = "/var/acme/cloudflare";
in {
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "vdesjardins@gmail.com";
      dnsProvider = "cloudflare";
      # Validate public challenge records without the local split-DNS resolver.
      dnsResolver = "1.1.1.1:53";
      environmentFile = "${credsDir}/env";
    };
  };

  system.activationScripts.acme-cloudflare-creds.text =
    # bash
    ''
      # using nixos-rebuild on remote host with sudo loses $HOME
      export HOME=/root

      mkdir -p ${credsDir}
      chmod 700 ${credsDir}

      cat << EOF > ${credsDir}/env
      CLOUDFLARE_EMAIL="$(${pkgs.passage}/bin/passage hosts/${hostName}/acme/cloudflare/email)"
      CLOUDFLARE_DNS_API_TOKEN="$(${pkgs.passage}/bin/passage hosts/${hostName}/acme/cloudflare/api-key)"
      EOF
    '';
}
