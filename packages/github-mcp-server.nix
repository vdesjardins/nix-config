{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-oPsH9pC8sWSxaVQxL5p+Ok4ed3mOtiVsNvQUH/DfCFk=";
  };

  vendorHash = "sha256-QztH+35KQReYsft50WBZMB0EEBWmQZiSA/mFzsvLSQU=";

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    mainProgram = "github-mcp-server";
  };
}
