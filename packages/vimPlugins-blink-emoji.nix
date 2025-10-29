{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "blink-emoji";
  version = "0-unstable-2025-10-22";

  src = fetchFromGitHub {
    owner = "moyiz";
    repo = "blink-emoji.nvim";
    rev = "066013e4c98a9318408ee3f1ca2dbcb6fa3e4c06";
    hash = "sha256-kQcyvZbgH878HFHcmxBw7CA2HzdxtSoWqJxKqVFf/8M=";
  };

  doCheck = false;

  meta = {
    description = "Emoji source for blink.cmp";
    homepage = "https://github.com/moyiz/blink-emoji.nvim";
  };
}
