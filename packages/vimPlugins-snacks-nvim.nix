{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin rec {
  pname = "snacks.nvim";
  version = "2.30.0";

  src = fetchFromGitHub {
    owner = "folke";
    repo = "snacks.nvim";
    rev = "v${version}";
    hash = "sha256-5m65Gvc6DTE9v7noOfm0+iQjDrqnrXYYV9QPnmr1JGY=";
  };

  doCheck = false;

  meta = {
    description = "🍿 A collection of QoL plugins for Neovim";
    homepage = "https://github.com/folke/snacks.nvim";
  };
}
