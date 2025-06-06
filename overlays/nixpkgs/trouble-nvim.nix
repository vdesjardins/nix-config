_inputs: _final: prev: let
  info = builtins.fromJSON (builtins.readFile ./trouble-nvim.json);
in {
  vimPlugins =
    prev.vimPlugins
    // {
      trouble-nvim = prev.vimUtils.buildVimPlugin rec {
        pname = "trouble.nvim";
        version = info.revision;

        src = prev.fetchFromGitHub {
          owner = "folke";
          repo = "trouble.nvim";
          rev = "v${version}";
          hash = info.hash;
        };

        doCheck = false;

        meta = {
          homepage = "https://github.com/folke/trouble.nvim";
        };
      };
    };
}
