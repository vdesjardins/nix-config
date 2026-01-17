{...}: {
  networking = {
    useDHCP = false;
    enableIPv6 = true;
  };

  services.resolved.settings = {
    Resolve.DNSStubListenerExtra = "[::1]:53";
  };

  systemd.network.enable = true;
  systemd.network.networks."20-wired" = {
    name = "en*";
    networkConfig = {
      DHCP = "yes";
    };
  };

  networking.nftables.enable = false;
}
