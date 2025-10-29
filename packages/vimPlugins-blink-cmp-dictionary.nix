{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "blink-cmp-dictionary";
  version = "2.0.0-unstable-2025-10-23";

  src = fetchFromGitHub {
    owner = "Kaiser-Yang";
    repo = "blink-cmp-dictionary";
    rev = "944b3b215b01303672d4213758db7c5c5a1e3c92";
    hash = "sha256-e8ucufhLdNnE8fBjSLaTJngEj1valYE9upH78y+wj4I=";
  };

  doCheck = false;

  meta = {
    description = "Emoji source for blink.cmp";
    homepage = "https://github.com/moyiz/blink-emoji.nvim";
  };
}
