{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin rec {
  pname = "codecompanion.nvim";
  version = "19.13.0";

  src = fetchFromGitHub {
    owner = "olimorris";
    repo = "codecompanion.nvim";
    rev = "v${version}";
    hash = "sha256-9jSFvxX9m1+pFNY7YNRPz4Emm1HzNW/MjvR9BNDZpAo=";
  };

  doCheck = false;

  meta = {
    homepage = "https://github.com/olimorris/codecompanion.nvim";
  };
}
