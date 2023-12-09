{...}: {
  programs.joshuto = {
    enable = true;
  };

  programs.zsh.shellAliases = {
    j = "joshuto";
  };
}
