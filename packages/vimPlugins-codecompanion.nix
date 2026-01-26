{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin rec {
  pname = "codecompanion.nvim";
  version = "18.5.1";

  src = fetchFromGitHub {
    owner = "olimorris";
    repo = "codecompanion.nvim";
    rev = "v${version}";
    hash = "sha256-NEgSYj+ja0EQTwPGur8D7PcECSdZ85z+w61vf1ES14s=";
  };

  doCheck = false;

  meta = {
    homepage = "https://github.com/olimorris/codecompanion.nvim";
  };
}
