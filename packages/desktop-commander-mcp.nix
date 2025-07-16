{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  ripgrep,
}: let
in
  buildNpmPackage rec {
    pname = "DesktopCommanderMCP";
    version = "0.2.4";

    src = fetchFromGitHub {
      owner = "wonderwhy-er";
      repo = "DesktopCommanderMCP";
      rev = "v${version}";
      hash = "sha256-sCd7Bd2OHERi28DbTzgP0mAHm69L0pQVMTr9xMKsB4c=";
    };

    npmDepsHash = "sha256-g/2QPUdfzkt45fxzMXS5BuoJ6EFwKweqX7sb0qN23as=";

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
