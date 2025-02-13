_inputs: _final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      codecompanion = prev.vimUtils.buildVimPlugin rec {
        pname = "codecompanion.nvim";
        version = "12.2.3";

        src = prev.fetchFromGitHub {
          owner = "olimorris";
          repo = "codecompanion.nvim";
          rev = "v${version}";
          hash = "sha256-fVLtunupR9cWFl52HLDX5R1UwlYEwFESZ8wdYsKYYvY=";
        };

        doCheck = false;

        meta = {
          homepage = "https://github.com/olimorris/codecompanion.nvim";
        };
      };
    };
}
