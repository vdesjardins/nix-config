{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  ripgrep,
}: let
in
  buildNpmPackage rec {
    pname = "DesktopCommanderMCP";
    version = "0.2.19";

    src = fetchFromGitHub {
      owner = "wonderwhy-er";
      repo = "DesktopCommanderMCP";
      rev = "v${version}";
      hash = "sha256-llCLeFc9JJNRFC/nIGjzIJ/YMh7+WEZ/DQn17tYyZCw=";
    };

    npmDepsHash = "sha256-S1CMAlgMOcWHcMs2CEjkz73HyI5y7jYVitADp9xWLLU=";

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
