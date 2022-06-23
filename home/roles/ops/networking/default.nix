{ pkgs, ... }: {
  home.packages = with pkgs; [
    tcpdump
    wireshark-cli
    termshark
    dnspeep
    mtr # network diagnostic tool
  ];
}
