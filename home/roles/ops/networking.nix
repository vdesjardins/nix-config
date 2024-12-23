{pkgs, ...}: {
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
}
