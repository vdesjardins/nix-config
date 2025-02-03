_inputs: _final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      snacks-nvim = prev.vimUtils.buildVimPlugin rec {
        pname = "snacks.nvim";
        version = "2.18.0";

        src = prev.fetchFromGitHub {
          owner = "folke";
          repo = "snacks.nvim";
          rev = "v${version}";
          hash = "sha256-90+LyldTortUMM7CpGZFH42QIP0efQhDshb6nw8pLXI=";
        };

        doCheck = false;

        meta = {
          description = "🍿 A collection of QoL plugins for Neovim";
          homepage = "https://github.com/folke/snacks.nvim";
        };
      };
    };
}
