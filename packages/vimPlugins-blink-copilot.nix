{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "blink-copilot";
  version = "1.4.1-unstable-2025-09-30";

  src = fetchFromGitHub {
    owner = "fang2hou";
    repo = "blink-copilot";
    rev = "5d35fd07fcc148be20442da1bdd2407e03263d7d";
    hash = "sha256-s57/vIMvWoumP/Sp+3JMv0bHOf4rq33aEWPMLJdsBpk=";
  };

  doCheck = false;

  meta = {
    description = "Configurable GitHub Copilot blink.cmp source for Neovim";
    homepage = "https://github.com/fang2hou/blink-copilot";
  };
}
