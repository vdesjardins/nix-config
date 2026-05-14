{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "blink-emoji";
  version = "0-unstable-2026-04-11";

  src = fetchFromGitHub {
    owner = "moyiz";
    repo = "blink-emoji.nvim";
    rev = "dff709139ad5389fb55ebab026e75278a12b325a";
    hash = "sha256-qBJ0zwkKlxZ6S6VzMusm9CCKx+EN1YOaBfdMb7xKQ5A=";
  };

  doCheck = false;

  meta = {
    description = "Emoji source for blink.cmp";
    homepage = "https://github.com/moyiz/blink-emoji.nvim";
  };
}
