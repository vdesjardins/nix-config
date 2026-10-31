{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin rec {
  pname = "codecompanion.nvim";
  version = "20.0.1";

  src = fetchFromGitHub {
    owner = "olimorris";
    repo = "codecompanion.nvim";
    rev = "v${version}";
    hash = "sha256-29Z/aTSK6xtLCNp+FJH1D89MpNztm6Hjgfz80XZVTlI=";
  };

  doCheck = false;

  meta = {
    homepage = "https://github.com/olimorris/codecompanion.nvim";
  };
}
