_inputs: _final: prev: let
  versioning = builtins.fromJSON (builtins.readFile ./blink-emoji.json);
in {
  vimPlugins =
    prev.vimPlugins
    // {
      blink-emoji = prev.vimUtils.buildVimPlugin {
        pname = "blink-emoji";
        version = versioning.version;

        src = prev.fetchFromGitHub {
          owner = "moyiz";
          repo = "blink-emoji.nvim";
          rev = versioning.revision;
          hash = versioning.hash;
        };

        doCheck = false;

        meta = {
          description = "Emoji source for blink.cmp";
          homepage = "https://github.com/moyiz/blink-emoji.nvim";
        };
      };
    };
}
