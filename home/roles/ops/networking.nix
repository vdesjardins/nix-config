{pkgs, ...}: {
  home.packages = with pkgs; [
    dig
    dnspeep # look at host dns queries
    mtr # network diagnostic tool
    tcpdump
    tcptraceroute
    termshark
    unixtools.ping
    wireshark-cli
  ];
}
