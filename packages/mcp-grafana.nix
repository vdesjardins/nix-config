{
  lib,
  buildGoModule,
  fetchFromGitHub,
}:
buildGoModule rec {
  pname = "mcp-grafana";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "grafana";
    repo = "mcp-grafana";
    tag = "v${version}";
    hash = "sha256-Tz2BPBTaglVvmcpcVR2mC8mlh/68x6SDQ32K2FvEdKw=";
  };

  vendorHash = "sha256-vdEHq742g4IkpIKqRNainCdRop4l60F5qdxQ9JFy1Cw=";

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
