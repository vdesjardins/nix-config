{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "mcp-grafana";
  version = "2.2.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "mcp-grafana";
    tag = "v${version}";
    hash = "sha256-0JwhO/CUewthPk5eAKOvQeweJFQ1A3zHIz8Wv8F/7vw=";
  };

  vendorHash = "sha256-szMCIObafZ0HpNuDbFTz5VhLk2DBx3vEm/UdLJU77v8=";

  subPackages = ["cmd/mcp-grafana"];

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
