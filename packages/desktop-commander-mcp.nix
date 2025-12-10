{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  ripgrep,
}:
buildNpmPackage rec {
  pname = "DesktopCommanderMCP";
  version = "0.2.29";

  src = fetchFromGitHub {
    owner = "wonderwhy-er";
    repo = "DesktopCommanderMCP";
    rev = "v${version}";
    hash = "sha256-D24XuyCnIDn9uPxDi4O9Trlbo14ceEAmADfPsVZYkPk=";
  };

  npmDepsHash = "sha256-VB7gL4eUbLiczM5ySf4/hNAVVEiWKnYrF/VLV5y9bpE=";

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
