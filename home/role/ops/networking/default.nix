{ pkgs, ... }: {
  home.packages = with pkgs; [
    tcpdump
    tshark
    termshark
    dnspeep
    mtr # network diagnostic tool
  ];
}
