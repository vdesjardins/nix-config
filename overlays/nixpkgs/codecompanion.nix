_inputs: _final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      codecompanion = prev.vimUtils.buildVimPlugin rec {
        pname = "codecompanion.nvim";
        version = "12.13.0";

        src = prev.fetchFromGitHub {
          owner = "olimorris";
          repo = "codecompanion.nvim";
          rev = "v${version}";
          hash = "sha256-8dhdsiq/WDbPJv6eVHAwvOQpuVCgG3NoTaCsaltciZg=";
        };

        doCheck = false;

        meta = {
          homepage = "https://github.com/olimorris/codecompanion.nvim";
        };
      };
    };
}
