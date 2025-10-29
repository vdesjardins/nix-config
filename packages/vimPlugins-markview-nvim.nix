{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin rec {
  pname = "markview.nvim";
  version = "26.0.1";

  src = fetchFromGitHub {
    owner = "OXY2DEV";
    repo = "markview.nvim";
    rev = "v${version}";
    hash = "sha256-c8kvtC9PuFtKPbdrTWQFX3Hsw7vwYXVDSQ5/W46s2ZM=";
    fetchSubmodules = true;
  };

  doCheck = false;

  meta.homepage = "https://github.com/OXY2DEV/markview.nvim/";
}
