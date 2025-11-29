{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin rec {
  pname = "codecompanion.nvim";
  version = "17.33.0";

  src = fetchFromGitHub {
    owner = "olimorris";
    repo = "codecompanion.nvim";
    rev = "v${version}";
    hash = "sha256-L/OKB6o7xEu+bCRu80ruVRmqMpNIiEL0Fgl+VpInaRs=";
  };

  doCheck = false;

  meta = {
    homepage = "https://github.com/olimorris/codecompanion.nvim";
  };
}
