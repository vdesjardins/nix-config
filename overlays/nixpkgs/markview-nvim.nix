_inputs: _final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      markview-nvim = prev.vimUtils.buildVimPlugin rec {
        pname = "markview.nvim";
        version = "25.7.0";

        src = prev.fetchFromGitHub {
          owner = "OXY2DEV";
          repo = "markview.nvim";
          rev = "v${version}";
          sha256 = "sha256-h1SNPkpJuU6zZHsDQ8OEmz7xH3nhWnBLubn0C9Ifd4k=";
          fetchSubmodules = true;
        };

        doCheck = false;

        meta.homepage = "https://github.com/OXY2DEV/markview.nvim/";
      };
    };
}
