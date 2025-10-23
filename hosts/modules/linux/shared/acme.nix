{pkgs, ...}: let
  credsDir = "/var/acme/cloudflare";
in {
  security.acme = {
    acceptTerms = true;
    defaults = {
      email = "vdesjardins@gmail.com";
      dnsProvider = "cloudflare";
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
      CLOUDFLARE_EMAIL="$(${pkgs.passage}/bin/passage hosts/home-server/acme/cloudflare/email)"
      CLOUDFLARE_DNS_API_TOKEN="$(${pkgs.passage}/bin/passage hosts/home-server/acme/cloudflare/api-key)"
      EOF
    '';
}
