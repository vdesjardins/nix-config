_inputs: _final: prev: let
  versioning = builtins.fromJSON (builtins.readFile ./codecompanion.json);
in {
  vimPlugins =
    prev.vimPlugins
    // {
      codecompanion = prev.vimUtils.buildVimPlugin {
        pname = "codecompanion.nvim";
        version = versioning.version;

        src = prev.fetchFromGitHub {
          owner = "olimorris";
          repo = "codecompanion.nvim";
          rev = versioning.revision;
          hash = versioning.hash;
        };

        doCheck = false;

        meta = {
          homepage = "https://github.com/olimorris/codecompanion.nvim";
        };
      };
    };
}
