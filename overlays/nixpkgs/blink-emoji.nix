_inputs: _final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      blink-emoji = prev.vimUtils.buildVimPlugin {
        pname = "blink-emoji";
        version = "2024-12-26";

        src = prev.fetchFromGitHub {
          owner = "moyiz";
          repo = "blink-emoji.nvim";
          rev = "699493775b61b94ead76841c981a51d3df350ea0";
          hash = "sha256-WHFifYQ7kBSVxjE9/y65/+UKbRnhmev3h2Ux1E5emBU=";
        };

        meta = {
          description = "Emoji source for blink.cmp";
          homepage = "https://github.com/moyiz/blink-emoji.nvim";
        };
      };
    };
}
