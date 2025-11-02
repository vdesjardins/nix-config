{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin rec {
  pname = "snacks.nvim";
  version = "2.28.0";

  src = fetchFromGitHub {
    owner = "folke";
    repo = "snacks.nvim";
    rev = "v${version}";
    hash = "sha256-Kr8NbQ4V0ShJktqQDygd6NN6A6szkcVMlTxhQjjs/AE=";
  };

  doCheck = false;

  meta = {
    description = "🍿 A collection of QoL plugins for Neovim";
    homepage = "https://github.com/folke/snacks.nvim";
  };
}
