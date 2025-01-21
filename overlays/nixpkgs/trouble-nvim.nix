_inputs: _final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      trouble-nvim = prev.vimUtils.buildVimPlugin {
        pname = "trouble.nvim";
        version = "2025-01-21";

        src = prev.fetchFromGitHub {
          owner = "folke";
          repo = "trouble.nvim";
          rev = "50481f414bd3c1a40122c1d759d7e424d5fafe84";
          hash = "sha256-Z2STeDZ8uhfyfH1TqSbRdWPYdPMxOb9s8/hLS76Fm5E=";
        };

        doCheck = false;

        meta = {
          homepage = "https://github.com/folke/trouble.nvim";
        };
      };
    };
}
