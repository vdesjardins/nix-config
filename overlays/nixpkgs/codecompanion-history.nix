_inputs: _final: prev: let
  versioning = builtins.fromJSON (builtins.readFile ./codecompanion-history.json);
in {
  vimPlugins =
    prev.vimPlugins
    // {
      codecompanion-history = prev.vimUtils.buildVimPlugin {
        pname = "codecompanion-history";
        version = versioning.version;

        src = prev.fetchFromGitHub {
          owner = "ravitemer";
          repo = "codecompanion-history.nvim";
          rev = versioning.revision;
          hash = versioning.hash;
        };

        doCheck = false;

        meta.homepage = "https://github.com/ravitemer/codecompanion-history.nvim";
      };
    };
}
