_inputs: _final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      markview-nvim = prev.vimUtils.buildVimPlugin rec {
        pname = "markview.nvim";
        version = "25.3.2";

        src = prev.fetchFromGitHub {
          owner = "OXY2DEV";
          repo = "markview.nvim";
          rev = "v${version}";
          sha256 = "sha256-YUGHAFTEfwSoXOS9hUcqi3i5C25uy7EYNAffumvfxGw=";
          fetchSubmodules = true;
        };

        doCheck = false;

        meta.homepage = "https://github.com/OXY2DEV/markview.nvim/";
      };
    };
}
