_inputs: _final: prev: {
  vimPlugins =
    prev.vimPlugins
    // {
      mcphub = prev.vimUtils.buildVimPlugin rec {
        pname = "mcphub";
        version = "5.0.0";

        src = prev.fetchFromGitHub {
          owner = "ravitemer";
          repo = "mcphub.nvim";
          rev = "v${version}";
          hash = "sha256-xXo7s5XCQ1+yoRrkaoqolwUlBJE6zMvmbOzACzVWK8E=";
        };

        doCheck = false;

        meta = {
          homepage = "https://github.com/ravitemer/mcphub.nvim";
        };
      };
    };
}
