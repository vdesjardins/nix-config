{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  ripgrep,
}:
buildNpmPackage rec {
  pname = "DesktopCommanderMCP";
  version = "0.2.21";

  src = fetchFromGitHub {
    owner = "wonderwhy-er";
    repo = "DesktopCommanderMCP";
    rev = "v${version}";
    hash = "sha256-xdaNVBrCDBU1rNW7ZiCzu8rmhwZYXGEdTnljxy4jKaI=";
  };

  npmDepsHash = "sha256-I+c5K65+SgsK2lZxHjrhXfo9CK9eziNimxMFNdy2wAs=";

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
