_inputs: _final: prev: let
  versioning = builtins.fromJSON (builtins.readFile ./kcl-nvim.json);
in {
  vimPlugins =
    prev.vimPlugins
    // {
      kcl = prev.vimUtils.buildVimPlugin {
        pname = "kcl.nvim";
        version = versioning.version;

        src = prev.fetchFromGitHub {
          owner = "kcl-lang";
          repo = "kcl.nvim";
          rev = versioning.revision;
          hash = versioning.hash;
        };

        doCheck = false;

        meta = {
          homepage = "https://github.com/kcl-lang/kcl.nvim";
        };
      };
    };
}
