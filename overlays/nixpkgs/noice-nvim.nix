_inputs: _final: prev: let
  versioning = builtins.fromJSON (builtins.readFile ./noice-nvim.json);
in {
  vimPlugins =
    prev.vimPlugins
    // {
      noice-nvim = let
        version = versioning.version;
      in (prev.vimUtils.buildVimPlugin {
        pname = "noice.nvim";
        inherit version;

        src = prev.fetchFromGitHub {
          owner = "folke";
          repo = "noice.nvim";
          rev = versioning.revision;
          hash = versioning.hash;
        };

        doCheck = false;

        meta = {
          description = "💥 Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu. ";
          homepage = "https://github.com/folke/noice.nvim";
        };
      });
    };
}
