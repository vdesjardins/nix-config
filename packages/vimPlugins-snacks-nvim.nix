{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin rec {
  pname = "snacks.nvim";
  version = "2.25.0";

  src = fetchFromGitHub {
    owner = "folke";
    repo = "snacks.nvim";
    rev = "v${version}";
    hash = "sha256-FtGnuqaJYlZdIt2pPPSlbLEtUVwJBcI7ogUS2KcIXEM=";
  };

  doCheck = false;

  meta = {
    description = "🍿 A collection of QoL plugins for Neovim";
    homepage = "https://github.com/folke/snacks.nvim";
  };
}
