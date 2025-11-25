{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "markdown-toc-nvim";
  version = "0-unstable-2024-09-11";

  src = fetchFromGitHub {
    owner = "hedyhli";
    repo = "markdown-toc.nvim";
    rev = "869af35bce0c27e2006f410fa3f706808db4843d";
    hash = "sha256-HfjE9xfahy1U+G4aSopRBt6Qz3FXxss41oJJcuvFh70=";
  };

  doCheck = false;

  meta = {
    homepage = "https://github.com/hedyhli/markdown-toc.nvim";
  };
}
