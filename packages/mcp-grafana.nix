{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "mcp-grafana";
  version = "0.7.7";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "mcp-grafana";
    tag = "v${version}";
    hash = "sha256-LmR9HgtW9hx8SQAh4JkoKPnwwtOghqPt2oDv7khcq2Q=";
  };

  vendorHash = "sha256-unoLSUasCUbFbml6q1lBCE0YBFENFkrpxXpXoZSo49s=";

  ldflags = [
    "-s"
    "-w"
  ];

  meta = {
    description = "MCP server for Grafana";
    homepage = "https://github.com/grafana/mcp-grafana";
    changelog = "https://github.com/grafana/mcp-grafana/releases/tag/v${version}";
    license = lib.licenses.asl20;
    mainProgram = "mcp-grafana";
  };
}
