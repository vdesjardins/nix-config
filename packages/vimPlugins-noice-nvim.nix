{
  fetchFromGitHub,
  vimUtils,
}:
vimUtils.buildVimPlugin {
  pname = "noice.nvim";
  version = "4.10.0-unstable-2025-10-28";

  src = fetchFromGitHub {
    owner = "folke";
    repo = "noice.nvim";
    rev = "5099348591f7d3ba9e547b1e631c694c65bbe0b9";
    hash = "sha256-PZ2HfV2AirZaxK5vFc+yJoOXXK1jKDzUQt//AXREgok=";
  };

  doCheck = false;

  meta = {
    description = "💥 Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu. ";
    homepage = "https://github.com/folke/noice.nvim";
  };
}
