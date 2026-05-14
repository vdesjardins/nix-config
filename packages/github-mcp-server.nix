{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-y6QGF2g9FhDxtWR//kaI5Xt2o+MwaNWCf2t0t61/vww=";
  };

  vendorHash = "sha256-fVNMtCpodsr1Z9E21osHb+e63ZQqFKYwi4fz4OsTJe0=";

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    mainProgram = "github-mcp-server";
  };
}
