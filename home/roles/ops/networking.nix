{pkgs, ...}: {
  home.packages = with pkgs; [
    dig
    dogdns
    dnspeep # look at host dns queries
    mtr # network diagnostic tool
    tcpdump
    tcptraceroute
    termshark
    unixtools.ping
    wireshark-cli
  ];
}
