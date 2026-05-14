{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "blink-cmp-dictionary";
  version = "0-unstable-2026-05-11";

  src = fetchFromGitHub {
    owner = "Kaiser-Yang";
    repo = "blink-cmp-dictionary";
    rev = "17ea03ba5c296310b9f74587b52fde1b04d84c1a";
    hash = "sha256-DfUXUKYNnnY0at1ayU/uRRGGGf4bmuuWvQar1XEUa5Q=";
  };

  doCheck = false;

  meta = {
    description = "Emoji source for blink.cmp";
    homepage = "https://github.com/moyiz/blink-emoji.nvim";
  };
}
