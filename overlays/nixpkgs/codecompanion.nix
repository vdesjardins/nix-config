_inputs: _final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      codecompanion = prev.vimUtils.buildVimPlugin rec {
        pname = "codecompanion.nvim";
        version = "11.25.2";

        src = prev.fetchFromGitHub {
          owner = "olimorris";
          repo = "codecompanion.nvim";
          rev = "v${version}";
          hash = "sha256-MKLvMsMXWsIS5nKKIbEmajnqh2aV2pnCG3IiplfsbO0=";
        };

        doCheck = false;

        meta = {
          homepage = "https://github.com/olimorris/codecompanion.nvim";
        };
      };
    };
}
