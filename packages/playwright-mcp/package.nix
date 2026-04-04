{
  fetchFromGitHub,
  buildNpmPackage,
  lib,
}:
buildNpmPackage rec {
  pname = "playwright-mcp";
  version = "0.0.70";

  src = fetchFromGitHub {
    owner = "microsoft";
    repo = "playwright-mcp";
    rev = "v${version}";
    hash = "sha256-dvFFG+/cYy09RjEMDIWncTNCcyaKoKH52qweYq0HHxU=";
  };

  npmDepsHash = "sha256-tyVigQYA/viB8Ycg++SfPF6WEWWulnfuJXZYOBGhhOQ=";

  dontNpmBuild = true;

  meta = with lib; {
    description = "Playwright MCP server";
    homepage = "https://github.com/microsoft/playwright-mcp";
    license = licenses.asl20;
    platforms = platforms.all;
    mainProgram = "mcp-server-playwright";
  };
}
