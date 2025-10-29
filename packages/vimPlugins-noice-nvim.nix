{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "noice.nvim";
  version = "4.10.0-unstable-2025-10-21";

  src = fetchFromGitHub {
    owner = "folke";
    repo = "noice.nvim";
    rev = "c86aea584d98be7ee1167ce4d4ef946fbd7f3ae0";
    hash = "sha256-1BW1yQ8yd/HF127CAqIC7ZayJJ2T+j6YCXQWm3vHrhQ=";
  };

  doCheck = false;

  meta = {
    description = "💥 Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu. ";
    homepage = "https://github.com/folke/noice.nvim";
  };
}
