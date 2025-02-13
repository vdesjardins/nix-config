_inputs: _final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      noice-nvim = let
        version = "2015-02-12";
      in (prev.vimUtils.buildVimPlugin {
        pname = "noice.nvim";
        inherit version;

        src = prev.fetchFromGitHub {
          owner = "folke";
          repo = "noice.nvim";
          rev = "0427460c2d7f673ad60eb02b35f5e9926cf67c59";
          hash = "sha256-0yu3JX7dXb9b+1REAVP+6K350OlYN6DBm8hEKgkQHgA=";
        };

        doCheck = false;

        meta = {
          description = "💥 Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu. ";
          homepage = "https://github.com/folke/noice.nvim";
        };
      });
    };
}
