{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  ripgrep,
}: let
in
  buildNpmPackage rec {
    pname = "DesktopCommanderMCP";
    version = "0.2.15";

    src = fetchFromGitHub {
      owner = "wonderwhy-er";
      repo = "DesktopCommanderMCP";
      rev = "v${version}";
      hash = "sha256-LHedb0XifGDd+8qTUslDNi3+0y4ypvI5lM+ZXNFU8oY=";
    };

    npmDepsHash = "sha256-ciHB/0/Df+150jaAZQPMCiRUtBN5rPf9SUqg7JSwePQ=";

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
