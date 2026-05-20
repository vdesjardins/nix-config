{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin rec {
  pname = "markview.nvim";
  version = "28.3.0";

  src = fetchFromGitHub {
    owner = "OXY2DEV";
    repo = "markview.nvim";
    rev = "v${version}";
    hash = "sha256-rqzC3RiRoglRtJ/UbWDVvvr1wNhqYJxlOj2dIoE6WfU=";
    fetchSubmodules = true;
  };

  doCheck = false;

  meta.homepage = "https://github.com/OXY2DEV/markview.nvim/";
}
