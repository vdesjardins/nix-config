{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin rec {
  pname = "snacks.nvim";
  version = "2.31.0";

  src = fetchFromGitHub {
    owner = "folke";
    repo = "snacks.nvim";
    rev = "v${version}";
    hash = "sha256-NSoZQajyYFGIUCLD1m6FRPgKRsyJSM0IWygg1ofZZBs=";
  };

  doCheck = false;

  meta = {
    description = "🍿 A collection of QoL plugins for Neovim";
    homepage = "https://github.com/folke/snacks.nvim";
  };
}
