_inputs: _final: prev: let
  versioning = builtins.fromJSON (builtins.readFile ./blink-copilot.json);
in {
  vimPlugins =
    prev.vimPlugins
    // {
      blink-copilot = prev.vimUtils.buildVimPlugin {
        pname = "blink-copilot";
        version = versioning.version;

        src = prev.fetchFromGitHub {
          owner = "fang2hou";
          repo = "blink-copilot";
          rev = versioning.revision;
          hash = versioning.hash;
        };

        doCheck = false;

        meta = {
          description = "Configurable GitHub Copilot blink.cmp source for Neovim";
          homepage = "https://github.com/fang2hou/blink-copilot";
        };
      };
    };
}
