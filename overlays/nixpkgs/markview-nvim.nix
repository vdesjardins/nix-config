_inputs: _final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      markview-nvim = prev.vimUtils.buildVimPlugin {
        pname = "markview.nvim";
        version = "2025-01-25";

        src = prev.fetchFromGitHub {
          owner = "OXY2DEV";
          repo = "markview.nvim";
          rev = "19ad95013815c640a33935d586b8b015d1037d66";
          sha256 = "sha256-MYKOBkaRP5J9C168xkM+mKECodil5eV3VvYqtjQCBxw=";
          fetchSubmodules = true;
        };

        doCheck = false;

        meta.homepage = "https://github.com/OXY2DEV/markview.nvim/";
      };
    };
}
