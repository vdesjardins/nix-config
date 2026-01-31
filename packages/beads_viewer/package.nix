{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  pname = "beads_viewer";
  version = "0.11.3";

  src = fetchFromGitHub {
    owner = "Dicklesworthstone";
    repo = "beads_viewer";
    rev = "v${version}";
    hash = "sha256-xpXVcwTYXmyaCCiviqFijjj5yvVyeyXAWgTY1N/A1CU=";
  };

  vendorHash = "sha256-rtIqTK6ez27kvPMbNjYSJKFLRbfUv88jq8bCfMkYjfs=";

  doCheck = false;

  meta = with lib; {
    description = "beads_viewer - A TUI viewer for beads issue tracking system";
    homepage = "https://github.com/Dicklesworthstone/beads_viewer";
    license = licenses.mit;
    maintainers = [];
    mainProgram = "bv";
  };
}
