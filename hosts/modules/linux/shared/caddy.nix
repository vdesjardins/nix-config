{...}: {
  services.tailscale.permitCertUid = "caddy";

  services.caddy = {
    enable = true;

    email = "vdesjardins@gmail.com";

    globalConfig =
      # caddyfile
      ''
        servers {
          protocols h1 h2 h3
        }

        grace_period 5s
      '';
  };
}
