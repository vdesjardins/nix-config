{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "blink-cmp-dictionary";
  version = "3.0.1-unstable-2026-02-26";

  src = fetchFromGitHub {
    owner = "Kaiser-Yang";
    repo = "blink-cmp-dictionary";
    rev = "35142bba869b869715e91a99d2f46bcf93fca4ae";
    hash = "sha256-idDHERqdqKB8/we00oVEo1sTDqrwPRTsuWmmG0ISeoE=";
  };

  doCheck = false;

  meta = {
    description = "Emoji source for blink.cmp";
    homepage = "https://github.com/moyiz/blink-emoji.nvim";
  };
}
