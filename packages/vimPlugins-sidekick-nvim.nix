{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin rec {
  pname = "sidekick.nvim";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "folke";
    repo = "sidekick.nvim";
    rev = "v${version}";
    hash = "sha256-DsDJPDIm07Uxxah7AP2GR7D+jxya9fnsJ1OS/ia5ipw=";
  };

  doCheck = false;

  meta = {
    description = "Your Neovim AI sidekick";
    homepage = "https://github.com/folke/sidekick.nvim";
  };
}
