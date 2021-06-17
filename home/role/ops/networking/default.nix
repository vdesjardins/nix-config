{ pkgs, ... }: { home.packages = with pkgs; [ tcpdump tshark termshark ]; }
