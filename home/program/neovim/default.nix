{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    package = pkgs.unstable.neovim-unwrapped;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    withPython3 = true;

    withNodeJs = true;

    withRuby = false;

  };

  home.packages = with pkgs;
    [
      python3
      python3Packages.pynvim

      # tools
      fzf
      bat
      ripgrep

      tree-sitter

      # lint/format
      unstable.efm-langserver
    ];

  xdg.configFile."nvim/lua".source = config/lua;
  xdg.configFile."nvim/init.lua".source = config/init.lua;
}
