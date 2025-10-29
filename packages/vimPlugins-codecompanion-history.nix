{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "codecompanion-history";
  version = "0-unstable-2025-09-07";

  src = fetchFromGitHub {
    owner = "ravitemer";
    repo = "codecompanion-history.nvim";
    rev = "eb99d256352144cf3b6a1c45608ec25544a0813d";
    hash = "sha256-0haETLOVASaFRpRF98IxFKOLbY873D5LDHfdcuEp0W4=";
  };

  doCheck = false;

  meta.homepage = "https://github.com/ravitemer/codecompanion-history.nvim";
}
