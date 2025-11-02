{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "blink-copilot";
  version = "1.4.1-unstable-2025-10-29";

  src = fetchFromGitHub {
    owner = "fang2hou";
    repo = "blink-copilot";
    rev = "7ad8209b2f880a2840c94cdcd80ab4dc511d4f39";
    hash = "sha256-cDvbUmnFZbPmU/HPISNV8zJV8WsH3COl3nGqgT5CbVQ=";
  };

  doCheck = false;

  meta = {
    description = "Configurable GitHub Copilot blink.cmp source for Neovim";
    homepage = "https://github.com/fang2hou/blink-copilot";
  };
}
