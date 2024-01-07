{pkgs, ...}: {
  programs.passage.enable = true;
  programs.rbw.enable = true;
  programs.ssh.enable = true;
  programs.gpg.enable = true;
  services.yubikey-agent.enable = true;

  home.packages = with pkgs; [
    bitwarden-cli
    gopass
    minisign
    yubikey-manager
  ];
}
