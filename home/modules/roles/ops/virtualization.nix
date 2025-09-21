{pkgs, ...}: {
  home.packages = with pkgs;
    [
      qemu
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.isLinux [
      OVMF
    ];
}
