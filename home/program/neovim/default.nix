{ pkgs, ... }:
let
  nvimConfig = pkgs.vimUtils.buildVimPlugin {
    name = "nvim-config";
    src = ./config;
  };

  pkgNeovim = pkgs.wrapNeovim pkgs.unstable.neovim-unwrapped
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

        packages.myVimPackage = with pkgs.neovimPlugins; {
          start = (builtins.attrValues pkgs.neovimPlugins) ++ [ nvimConfig ];
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

      # tools
      fzf
      bat
      ripgrep
      vale # syntax-aware linter for prose
    ];

  xdg.configFile."nvim/lua".source = config/lua;
  xdg.configFile."nvim/init.lua".source = config/init.lua;
}
