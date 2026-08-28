{pkgs, ...}: {
  home.packages = with pkgs;
    [
      qemu
    ]
    ++ pkgs.lib.optionals pkgs.stdenv.hostPlatform.isLinux [
      OVMF
    ];
}
