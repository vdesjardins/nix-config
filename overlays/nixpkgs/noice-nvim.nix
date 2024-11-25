_inputs: _self: super: {
  vimPlugins =
    super.vimPlugins
    // {
      noice-nvim = super.vimUtils.buildVimPlugin {
        pname = "noice.nvim";
        version = "2024-11-20";
        src = super.fetchFromGitHub {
          owner = "folke";
          repo = "noice.nvim";
          rev = "203f74adaae11d47440a667555b4af9156be807b";
          sha256 = "sha256-Q8EWrPkhpSemkZnx5+DqYFNeHx/VxQSLxTjkcDHkdao=";
        };
        meta.homepage = "https://github.com/folke/noice.nvim/";
      };
    };
}
