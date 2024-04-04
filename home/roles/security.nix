{pkgs, ...}: {
  modules.shell.tools = {
    ssh.enable = true;
    gpg.enable = true;
    gpg-agent.enable = true;
  };

  home.packages = with pkgs; [
    gopass
    minisign
    yubikey-manager
  ];
}
