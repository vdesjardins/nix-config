{ config, pkgs, ... }:
{
  programs.neovim = {
    plugins = with pkgs.vimPlugins; [
      emmet-vim
      # vim-css3-syntax
      typescript-vim
      vim-javascript
      # vim-jsx
      # vim-styled-components
    ];
  };
}
