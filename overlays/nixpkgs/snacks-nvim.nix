_inputs: _final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      snacks-nvim = prev.vimUtils.buildVimPlugin rec {
        pname = "snacks.nvim";
        version = "2.17.0";

        src = prev.fetchFromGitHub {
          owner = "folke";
          repo = "snacks.nvim";
          rev = "v${version}";
          hash = "sha256-SwMr2R3/JBwzHlEyFt2fujUQCUfmJJSjVNd1JKVIoHM=";
        };

        doCheck = false;

        meta = {
          description = "🍿 A collection of QoL plugins for Neovim";
          homepage = "https://github.com/folke/snacks.nvim";
        };
      };
    };
}
