{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-dbzO8yTAIfdAwcZEdoJqp+loPQea8iRSsAHdk2DfZ2A=";
  };

  vendorHash = "sha256-gVR7Md3xYrPpeMhHRTKCQKCJvRRIl85uXo+QwlVaPzk=";

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    mainProgram = "github-mcp-server";
  };
}
