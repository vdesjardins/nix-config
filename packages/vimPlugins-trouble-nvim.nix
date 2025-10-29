{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin rec {
  pname = "trouble.nvim";
  version = "3.7.1";

  src = fetchFromGitHub {
    owner = "folke";
    repo = "trouble.nvim";
    rev = "v${version}";
    hash = "sha256-F3LSA1iAF8TEI7ecyuWVe3FrpSddUf3OjJA/KGfdW/8=";
  };

  doCheck = false;

  meta = {
    homepage = "https://github.com/folke/trouble.nvim";
  };
}
