{pkgs, ...}: {
  modules.shell.tools = {
    passage.enable = true;
    rbw.enable = true;
  };
}
