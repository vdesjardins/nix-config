_inputs: _final: prev: let
  versioning = builtins.fromJSON (builtins.readFile ./blink-cmp-dictionary.json);
in {
  vimPlugins =
    prev.vimPlugins
    // {
      blink-cmp-dictionary = prev.vimUtils.buildVimPlugin {
        pname = "blink-cmp-dictionary";
        version = versioning.version;

        src = prev.fetchFromGitHub {
          owner = "Kaiser-Yang";
          repo = "blink-cmp-dictionary";
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
