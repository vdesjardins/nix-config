{ pkgs, ... }:
{
  programs.neovim = {
    enable = true;

    package = pkgs.neovim-nightly.overrideAttrs (
      oldAttrs: rec {
        nativeBuildInputs = oldAttrs.buildInputs ++ (
          with pkgs;
          [ gettext pkgconfig unzip cmake tree-sitter ]
        );
      }
    );

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

      # lint/format
      efm-langserver
    ];

  xdg.configFile."nvim/lua".source = config/lua;
  xdg.configFile."nvim/init.lua".source = config/init.lua;
}
