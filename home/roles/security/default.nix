{pkgs, ...}: {
  imports = [
    ../../programs/passage
  ];

  home.packages = with pkgs; [
    gopass
    minisign
    yubikey-manager
  ];
}
