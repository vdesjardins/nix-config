{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "0.30.2";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-o3EGmImAjiTQTd/iwCiDArj4fPfS+8aArEF7KQNZK8I=";
  };

  vendorHash = "sha256-rv7mZQ2/j4R9s3p+Psq5E2I99zFtnieGc3eaMT3ykqQ=";

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    mainProgram = "github-mcp-server";
  };
}
