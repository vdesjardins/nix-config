{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin rec {
  pname = "markview.nvim";
  version = "27.0.0";

  src = fetchFromGitHub {
    owner = "OXY2DEV";
    repo = "markview.nvim";
    rev = "v${version}";
    hash = "sha256-Yr4gsB1aR8PYxG8Gtfm37mHlhKtvlToz8gxP46zZKo4=";
    fetchSubmodules = true;
  };

  doCheck = false;

  meta.homepage = "https://github.com/OXY2DEV/markview.nvim/";
}
