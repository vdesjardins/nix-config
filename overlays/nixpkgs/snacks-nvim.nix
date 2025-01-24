_inputs: _final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      snacks-nvim = prev.vimUtils.buildVimPlugin {
        pname = "snacks.nvim";
        version = "2.15.0";

        src = prev.fetchFromGitHub {
          owner = "folke";
          repo = "snacks.nvim";
          rev = "v2.15.0";
          hash = "sha256-N5UtYPhelXVelun8NSHZJa42IbBDX9TRGpYppEiCwBA=";
        };

        doCheck = false;

        meta = {
          description = "🍿 A collection of QoL plugins for Neovim";
          homepage = "https://github.com/folke/snacks.nvim";
        };
      };
    };
}
