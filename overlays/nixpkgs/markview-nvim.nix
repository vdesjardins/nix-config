_inputs: _final: prev: let
  info = builtins.fromJSON (builtins.readFile ./markview-nvim.json);
in {
  vimPlugins =
    prev.vimPlugins
    // {
      markview-nvim = prev.vimUtils.buildVimPlugin rec {
        pname = "markview.nvim";
        version = info.revision;

        src = prev.fetchFromGitHub {
          owner = "OXY2DEV";
          repo = "markview.nvim";
          rev = "v${version}";
          sha256 = info.hash;
          fetchSubmodules = true;
        };

        doCheck = false;

        meta.homepage = "https://github.com/OXY2DEV/markview.nvim/";
      };
    };
}
