_inputs: _final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      blink-cmp-dictionary = prev.vimUtils.buildVimPlugin {
        pname = "blink-cmp-dictionary";
        version = "2025-02-12";

        src = prev.fetchFromGitHub {
          owner = "Kaiser-Yang";
          repo = "blink-cmp-dictionary";
          rev = "06bc48096e2c5cce57f04843ddcb59941532c2d6";
          hash = "sha256-SPrOlzo4nf7foONhWIMzAk8qYpPJR9Ogki8f3KHOKZk=";
        };

        doCheck = false;

        meta = {
          description = "Emoji source for blink.cmp";
          homepage = "https://github.com/moyiz/blink-emoji.nvim";
        };
      };
    };
}
