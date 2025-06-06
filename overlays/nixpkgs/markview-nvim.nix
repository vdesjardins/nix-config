_inputs: _final: prev: let
  versioning = builtins.fromJSON (builtins.readFile ./markview-nvim.json);
in {
  vimPlugins =
    prev.vimPlugins
    // {
      markview-nvim = prev.vimUtils.buildVimPlugin {
        pname = "markview.nvim";
        version = versioning.version;

        src = prev.fetchFromGitHub {
          owner = "OXY2DEV";
          repo = "markview.nvim";
          rev = versioning.revision;
          hash = versioning.hash;
          fetchSubmodules = true;
        };

        doCheck = false;

        meta.homepage = "https://github.com/OXY2DEV/markview.nvim/";
      };
    };
}
