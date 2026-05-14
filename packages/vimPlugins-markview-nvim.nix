{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin rec {
  pname = "markview.nvim";
  version = "28.2.0";

  src = fetchFromGitHub {
    owner = "OXY2DEV";
    repo = "markview.nvim";
    rev = "v${version}";
    hash = "sha256-/sO6gNKNwkQDSMjCesrHynCNSXGhDCoN8youVdJm6t4=";
    fetchSubmodules = true;
  };

  doCheck = false;

  meta.homepage = "https://github.com/OXY2DEV/markview.nvim/";
}
