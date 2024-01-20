{pkgs, ...}: {
  modules.shell.tools = {
    passage.enable = true;
    rbw.enable = true;
    ssh.enable = true;
    gpg.enable = true;
    yubikey-agent.enable = true;
  };

  home.packages = with pkgs; [
    bitwarden-cli
    gopass
    minisign
    yubikey-manager
  ];
}
