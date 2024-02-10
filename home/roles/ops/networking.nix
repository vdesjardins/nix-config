{pkgs, ...}: {
  home.packages = with pkgs; [
    dig
    dogdns
    dnspeep # look at host dns queries
    mtr # network diagnostic tool
    tcpdump
    tcpflow
    tcptraceroute
    termshark
    unixtools.ping
    wireshark-cli
  ];
}
