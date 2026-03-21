{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin rec {
  pname = "sidekick.nvim";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "folke";
    repo = "sidekick.nvim";
    rev = "v${version}";
    hash = "sha256-k3TCGI3pM7gGMkHo1eQMKda4ZhoeIKxjQQMEeI8jzQ0=";
  };

  doCheck = false;

  meta = {
    description = "Your Neovim AI sidekick";
    homepage = "https://github.com/folke/sidekick.nvim";
  };
}
