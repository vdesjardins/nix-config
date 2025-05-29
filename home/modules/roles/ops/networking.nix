{
  config,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.roles.ops.networking;
in {
  options.roles.ops.networking = {
    enable = mkEnableOption "ops.networking";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      dig
      dnspeep # look at host dns queries
      dogdns
      iperf
      mtr # network diagnostic tool
      nmap
      tcpdump
      tcpflow
      tcptraceroute
      termshark
      unixtools.ping
      wireshark-cli
    ];
  };
}
