{pkgs, ...}: {
  imports = [
    ../../programs/passage
    ../../programs/rbw
  ];

  home.packages = with pkgs; [
    bitwarden-cli
    gopass
    minisign
    yubikey-manager
  ];
}
