{ pkgs, ... }:
let
  nvimConfig = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-config";
    src = ./config;
  };

  plugins = pkgs.neovimPlugins // {
    nvim-treesitter = pkgs.neovimPlugins.nvim-treesitter.overrideAttrs
      (_: {
        postPatch =
          let
            grammars = pkgs.unstable.tree-sitter.withPlugins (_: pkgs.unstable.tree-sitter.allGrammars);
          in
          ''
            rm -r parser
            ln -s ${grammars} parser
          '';
      });
  };

  pkgNeovim = pkgs.wrapNeovim pkgs.neovim-nightly
    {
      viAlias = true;
      vimAlias = true;
      # vimdiffAlias = true;

      withPython3 = true;
      withNodeJs = true;
      withRuby = false;

      configure = {
        customRC = ''
          luafile ${nvimConfig.out}/init.lua
        '';

        packages.myVimPackage = {
          start = (builtins.attrValues plugins) ++ [ nvimConfig ];
        };
      };
    };
in
{
  home.packages = with pkgs;
    [
      pkgNeovim
      python3
      python3Packages.pynvim
      tree-sitter
      (tree-sitter.withPlugins (_: tree-sitter.allGrammars))

      # tools
      fzf
      bat
      ripgrep
      vale # syntax-aware linter for prose
    ];
}
