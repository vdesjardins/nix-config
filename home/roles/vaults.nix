{pkgs, ...}: {
  modules.shell.tools = {
    passage.enable = true;
    rbw.enable = true;
  };

  home.packages = with pkgs; [
    bitwarden-cli
  ];
}
