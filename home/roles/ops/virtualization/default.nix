{ pkgs, ... }: {
  home.packages = with pkgs; [
    unstable.qemu
    unstable.vagrant
  ] ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
    unstable.OVMF
  ];
}
