{config, ...}: {
  programs.ripgrep = {
    enable = true;

    arguments = [
      "--max-columns=150"
      "--max-columns-preview"
      "--hidden"
      "--type-add=zshrc:*.zsh*"
      "--type-add=bashrc:*.sh*"
      "--type-add=automake:*makefile.in*"
      "--glob=!git/*"
      "--glob=!.git/*"
      "--ignore-case"
    ];
  };
}
