{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "codecompanion-history";
  version = "0-unstable-2025-12-13";

  src = fetchFromGitHub {
    owner = "ravitemer";
    repo = "codecompanion-history.nvim";
    rev = "8c6ca9f998aeef89f3543343070f8562bf911fb4";
    hash = "sha256-t76g49Teln5OXfplUaph++1vkvUPAtlWte71y1sebUs=";
  };

  doCheck = false;

  meta.homepage = "https://github.com/ravitemer/codecompanion-history.nvim";
}
