{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  bun,
  esbuild,
}:
buildNpmPackage {
  pname = "opencode-notifier";
  version = "0.1.13-unstable-2026-01-14";

  nativeBuildInputs = [bun esbuild];

  src = fetchFromGitHub {
    owner = "mohak34";
    repo = "opencode-notifier";
    rev = "46838542008a4b03298bdfdfe75f152dacbb5a5b";
    hash = "sha256-l9K2smgk+pKBOmomqKQpbF+TgHaErOnTYx+631aXaf8=";
  };

  npmDepsHash = "sha256-1sTcKljeigGqjoJ2sJe96pfJpDZO0dYEj/INtBD3d7c=";

  packageLock = ./package-lock.json;

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  installPhase = ''
    mkdir -p $out
    cp dist/index.js $out/opencode-notifier.js
  '';

  meta = with lib; {
    description = "OpenCode plugin that sends system notifications and plays sounds when permission is needed, generation completes, or errors occur";
    homepage = "https://github.com/mohak34/opencode-notifier";
    license = licenses.mit;
    program = "opencode-notifier";
  };
}
