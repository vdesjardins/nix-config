_inputs: _final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      codecompanion = prev.vimUtils.buildVimPlugin rec {
        pname = "codecompanion.nvim";
        version = "14.8.1";

        src = prev.fetchFromGitHub {
          owner = "olimorris";
          repo = "codecompanion.nvim";
          rev = "v${version}";
          hash = "sha256-kkT5/p8Rx3QtB3mgMI6mJSyGLMhMLN+f0O114Cyncgc=";
        };

        doCheck = false;

        meta = {
          homepage = "https://github.com/olimorris/codecompanion.nvim";
        };
      };
    };
}
