_inputs: _final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      blink-emoji = prev.vimUtils.buildVimPlugin {
        pname = "blink-emoji";
        version = "2025-01-08";

        src = prev.fetchFromGitHub {
          owner = "moyiz";
          repo = "blink-emoji.nvim";
          rev = "81e6c080d1e64c9ef548534c51147fd8063481c8";
          hash = "sha256-xzBMFc1BwCNEWJGFWQbXSuxZ4WsiTs2gbFdPW+nSBc4=";
        };

        doCheck = false;

        meta = {
          description = "Emoji source for blink.cmp";
          homepage = "https://github.com/moyiz/blink-emoji.nvim";
        };
      };
    };
}
