_inputs: _final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      kcl = prev.vimUtils.buildVimPlugin {
        pname = "kcl.nvim";
        version = "2025-03-09";

        src = prev.fetchFromGitHub {
          owner = "kcl-lang";
          repo = "kcl.nvim";
          rev = "beededb5a8ed01ba2d121ed053aa6380ecb59597";
          hash = "sha256-8tslNwnprsrhRjW6Wf+pzVvtJyfVUIslb1Sg5X5ERpc=";
        };

        doCheck = false;

        meta = {
          homepage = "https://github.com/kcl-lang/kcl.nvim";
        };
      };
    };
}
