{pkgs, ...}: {
  home.packages = with pkgs; [
    dnspeep
    mtr # network diagnostic tool
    tcpdump
    tcptraceroute
    termshark
    wireshark-cli
  ];
}
