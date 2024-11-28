_inputs: _final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      easypick-nvim = prev.vimUtils.buildVimPlugin {
        pname = "easypick-nvim";
        version = "2024-11-23";

        src = prev.fetchFromGitHub {
          owner = "axkirillov";
          repo = "easypick.nvim";
          rev = "a8772f39519574df1ed49110b4fe02456a240530";
          hash = "sha256-Zwwx9PywdmSaHPo2OPFaG+gs7Y6yOzYBlpjcfpLfcKU=";
        };

        meta = {
          description = "A neovim plugin that lets you easily create Telescope pickers from arbitrary console commands";
          homepage = "https://github.com/axkirillov/easypick.nvim";
        };
      };
    };
}
