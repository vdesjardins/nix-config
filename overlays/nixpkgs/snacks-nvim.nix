_inputs: _final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      snacks-nvim = let
        version = "2.21.0";
      in (prev.vimUtils.buildVimPlugin {
        pname = "snacks.nvim";
        inherit version;

        src = prev.fetchFromGitHub {
          owner = "folke";
          repo = "snacks.nvim";
          rev = "v${version}";
          hash = "sha256-COvKNofUMiNV9MZvP18dtmkNSMXeTlumN2sIeBl4VqE=";
        };

        doCheck = false;

        meta = {
          description = "🍿 A collection of QoL plugins for Neovim";
          homepage = "https://github.com/folke/snacks.nvim";
        };
      });
    };
}
