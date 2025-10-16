{
  lib,
  fetchFromGitHub,
  buildNpmPackage,
  ripgrep,
}: let
in
  buildNpmPackage rec {
    pname = "DesktopCommanderMCP";
    version = "0.2.17";

    src = fetchFromGitHub {
      owner = "wonderwhy-er";
      repo = "DesktopCommanderMCP";
      rev = "v${version}";
      hash = "sha256-PSjM0flv/u1kKupYcM/xnMfk8W/E97gAPszpFnsUk3Q=";
    };

    npmDepsHash = "sha256-LP15GcAnXdV9EsQS5031wamTHOvm7KtpLMqYpTmy/48=";

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
