{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin rec {
  pname = "markview.nvim";
  version = "29.0.0";

  src = fetchFromGitHub {
    owner = "OXY2DEV";
    repo = "markview.nvim";
    rev = "v${version}";
    hash = "sha256-E7CBnPP3VYo/jkylhg4IGXYHwdqDdCoNrWc059hbzZw=";
    fetchSubmodules = true;
  };

  doCheck = false;

  meta.homepage = "https://github.com/OXY2DEV/markview.nvim/";
}
