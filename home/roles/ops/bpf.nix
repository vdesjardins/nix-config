{pkgs, ...}: {
  home.packages = with pkgs; [bcc bpftool linuxPackages.bpftrace];
}
