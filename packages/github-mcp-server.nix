{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "0.28.1";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-lcDVa0w7+Ht80ClL9V8mpefbEoBOL+7MMYCVTzaJsZk=";
  };

  vendorHash = "sha256-V5JHwgryCPyEOheJfPU+WY32oBU60VhCXGFx+rQ+qNw=";

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    mainProgram = "github-mcp-server";
  };
}
