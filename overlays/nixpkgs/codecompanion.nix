_inputs: _final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      codecompanion = prev.vimUtils.buildVimPlugin rec {
        pname = "codecompanion.nvim";
        version = "15.1.4";

        src = prev.fetchFromGitHub {
          owner = "olimorris";
          repo = "codecompanion.nvim";
          rev = "v${version}";
          hash = "sha256-7w7EepUbkoKRRerljJ3q1J13gxQfHmQW4DO43vYQL7E=";
        };

        doCheck = false;

        meta = {
          homepage = "https://github.com/olimorris/codecompanion.nvim";
        };
      };
    };
}
