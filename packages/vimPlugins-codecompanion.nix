{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin rec {
  pname = "codecompanion.nvim";
  version = "19.9.0";

  src = fetchFromGitHub {
    owner = "olimorris";
    repo = "codecompanion.nvim";
    rev = "v${version}";
    hash = "sha256-czV3xRahscMDRLpRRKiqKkbL2wsKkaTUA59U3erZUWU=";
  };

  doCheck = false;

  meta = {
    homepage = "https://github.com/olimorris/codecompanion.nvim";
  };
}
