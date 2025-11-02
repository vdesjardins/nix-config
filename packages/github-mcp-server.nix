{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "github-mcp-server";
  version = "0.20.1";

  src = fetchFromGitHub {
    owner = "github";
    repo = "github-mcp-server";
    rev = "v${version}";
    hash = "sha256-gB2MXeQQjVP/b+3hne6Mauork5szSOFz4uWIGzecN+U=";
  };

  vendorHash = "sha256-DcRpKFsCdGV3sOVHeyZbo/djVVBkuxRgFh7Z5yyElRw=";

  meta = with lib; {
    description = "GitHub's official MCP Server";
    homepage = "https://github.com/github/github-mcp-server";
    license = licenses.mit;
    mainProgram = "github-mcp-server";
  };
}
