_inputs: _final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      markview-nvim = prev.vimUtils.buildVimPlugin rec {
        pname = "markview.nvim";
        version = "25.6.0";

        src = prev.fetchFromGitHub {
          owner = "OXY2DEV";
          repo = "markview.nvim";
          rev = "v${version}";
          sha256 = "sha256-yqUOlV0g3P+QbcuOCp8iPuY8vTfYkNbUxSSxTcKwBx4=";
          fetchSubmodules = true;
        };

        doCheck = false;

        meta.homepage = "https://github.com/OXY2DEV/markview.nvim/";
      };
    };
}
