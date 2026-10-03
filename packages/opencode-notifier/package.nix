{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  bun,
  esbuild,
}:
buildNpmPackage {
  pname = "opencode-notifier";
  version = "0.6.1-unstable-2026-10-03";

  nativeBuildInputs = [bun esbuild];

  src = fetchFromGitHub {
    owner = "mohak34";
    repo = "opencode-notifier";
    rev = "e3fcd8d4196baa975675bdb5ced8705cf34d8143";
    hash = "sha256-pE25N5z08KPcXTVAGoL2GilT8BWBqrlbHtK6AAMhBiQ=";
  };

  npmDepsHash = "sha256-npF9p0GZvlFsxf2STXYQQePZmOZyM+Vu5Pl5qq5nJP0=";

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
