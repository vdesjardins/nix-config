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
      tree-sitter

      # tools
      fzf
      bat
      ripgrep
      vale # syntax-aware linter for prose
    ];

  xdg.configFile."nvim/lua".source = config/lua;
  xdg.configFile."nvim/init.lua".source = config/init.lua;
}
