{
  modules.darwin.app-symlinks.enable = true;

  programs.zsh.shellGlobalAliases = {
    CL = "|& pbcopy";
  };
}
