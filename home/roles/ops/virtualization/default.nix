{pkgs, ...}: {
  home.packages = with pkgs;
    [
      unstable.qemu
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      unstable.vagrant
      unstable.OVMF
    ];
}
