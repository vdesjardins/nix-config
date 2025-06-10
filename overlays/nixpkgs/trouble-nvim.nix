_inputs: _final: prev: let
  versioning = builtins.fromJSON (builtins.readFile ./trouble-nvim.json);
in {
  vimPlugins =
    prev.vimPlugins
    // {
      trouble-nvim = prev.vimUtils.buildVimPlugin {
        pname = "trouble.nvim";
        version = versioning.version;

        src = prev.fetchFromGitHub {
          owner = "folke";
          repo = "trouble.nvim";
          rev = versioning.revision;
          hash = versioning.hash;
        };

        doCheck = false;

        meta = {
          homepage = "https://github.com/folke/trouble.nvim";
        };
      };
    };
}
