{pkgs, ...}: {
  home.packages = with pkgs; [bcc bpftools linuxPackages.bpftrace];
}
