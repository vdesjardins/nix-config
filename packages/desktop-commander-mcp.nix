{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  ripgrep,
}:
buildNpmPackage rec {
  pname = "DesktopCommanderMCP";
  version = "0.2.23";

  src = fetchFromGitHub {
    owner = "wonderwhy-er";
    repo = "DesktopCommanderMCP";
    rev = "v${version}";
    hash = "sha256-RJE7nLYVzZuy5i0uO5rRewa0VYiYJpmNQ5i3ta+cguY=";
  };

  npmDepsHash = "sha256-DDQ/z1GHB09pP1Wfr58JN8CXPqKL/p8eYy6WN5v3Qxc=";

  # do not run install script, put ripgrep ourselves at the right place
  npmRebuildFlags = ["--ignore-scripts"];
  postBuild = ''
    find -path "*@vscode/ripgrep" -type d \
      -execdir mkdir -p {}/bin \; \
      -execdir ln -s ${ripgrep}/bin/rg {}/bin/rg \;
  '';

  meta = with lib; {
    description = "MCP server for terminal operations and file editing";
    homepage = "https://github.com/wonderwhy-er/DesktopCommanderMCP";
    license = licenses.mit;
    mainProgram = "desktop-commander";
  };
}
