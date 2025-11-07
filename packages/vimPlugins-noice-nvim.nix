{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "noice.nvim";
  version = "4.10.0-unstable-2025-11-03";

  src = fetchFromGitHub {
    owner = "folke";
    repo = "noice.nvim";
    rev = "7bfd942445fb63089b59f97ca487d605e715f155";
    hash = "sha256-FKzhFVmPxshDV4mWpD3LofjRpd6pXesf9QQei1s5rAo=";
  };

  doCheck = false;

  meta = {
    description = "💥 Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu. ";
    homepage = "https://github.com/folke/noice.nvim";
  };
}
