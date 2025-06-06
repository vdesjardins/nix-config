_inputs: _final: prev: let
  info = builtins.fromJSON (builtins.readFile ./snacks-nvim.json);
in {
  vimPlugins =
    prev.vimPlugins
    // {
      snacks-nvim = let
        version = info.revision;
      in (prev.vimUtils.buildVimPlugin {
        pname = "snacks.nvim";
        inherit version;

        src = prev.fetchFromGitHub {
          owner = "folke";
          repo = "snacks.nvim";
          rev = "v${version}";
          hash = info.hash;
        };

        doCheck = false;

        meta = {
          description = "🍿 A collection of QoL plugins for Neovim";
          homepage = "https://github.com/folke/snacks.nvim";
        };
      });
    };
}
