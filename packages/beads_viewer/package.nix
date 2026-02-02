{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule {
  pname = "beads_viewer";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "Dicklesworthstone";
    repo = "beads_viewer";
    rev = "1845695ca708cf7e23bcf99f7e0a02ac2590c7d3";
    hash = "sha256-2by4QXFyAeHtX1h/uZSWUwt8dmrZOCDz1n6IdDTQfcs=";
  };

  vendorHash = null;

  doCheck = false;

  meta = with lib; {
    description = "beads_viewer - A TUI viewer for beads issue tracking system";
    homepage = "https://github.com/Dicklesworthstone/beads_viewer";
    license = licenses.mit;
    maintainers = [];
    mainProgram = "bv";
  };
}
