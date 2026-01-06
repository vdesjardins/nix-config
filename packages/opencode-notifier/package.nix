{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  bun,
  esbuild,
}:
buildNpmPackage {
  pname = "opencode-notifier";
  version = "0-unstable-2026-01-04";

  nativeBuildInputs = [ bun esbuild ];

  src = fetchFromGitHub {
    owner = "mohak34";
    repo = "opencode-notifier";
    rev = "23234e3cfff142a5ee042aa1c85719c460541e67";
    hash = "sha256-hsdV73r4h2CF1P9LhX+bhiS7CwK9Kx2XKDwlxcgvgtk=";
  };

  npmDepsHash = "sha256-oHKLtZRqBVb2C7f2ESVCHjbqPbp0IFFqO2zf6jaI5bc=";

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
