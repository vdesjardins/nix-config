{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "blink-cmp-dictionary";
  version = "0-unstable-2026-06-01";

  src = fetchFromGitHub {
    owner = "Kaiser-Yang";
    repo = "blink-cmp-dictionary";
    rev = "898a958cece34da20524d04ebc032a92a9565643";
    hash = "sha256-eV0/8ga2ZE0HLrFN24k6MIGFNl/3zSr6/nqF8MwDDmQ=";
  };

  doCheck = false;

  meta = {
    description = "Emoji source for blink.cmp";
    homepage = "https://github.com/moyiz/blink-emoji.nvim";
  };
}
