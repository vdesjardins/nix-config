{pkgs, ...}: {
  programs.nixvim = {
    extraPlugins = [
      pkgs.vimPlugins.vim-rsi # emacs style keybings
    ];
  };
}
