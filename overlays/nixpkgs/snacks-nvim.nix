_inputs: _final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      snacks-nvim = prev.vimUtils.buildVimPlugin {
        pname = "snacks.nvim";
        version = "2025-01-19";

        src = prev.fetchFromGitHub {
          owner = "folke";
          repo = "snacks.nvim";
          rev = "eb0e5b7efe603bea7a0823ffaed13c52b395d04b";
          hash = "sha256-T015Pt9HfzABHQSrH40Gi798T/oTJD1mtc2/a63IYhw=";
        };

        doCheck = false;

        meta = {
          description = "🍿 A collection of QoL plugins for Neovim";
          homepage = "https://github.com/folke/snacks.nvim";
        };
      };
    };
}
