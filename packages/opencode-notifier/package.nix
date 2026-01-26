{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  bun,
  esbuild,
}:
buildNpmPackage {
  pname = "opencode-notifier";
  version = "0.1.15-unstable-2026-01-20";

  nativeBuildInputs = [bun esbuild];

  src = fetchFromGitHub {
    owner = "mohak34";
    repo = "opencode-notifier";
    rev = "1dd08a1cf820591ce3da8ee92d30512d2d178773";
    hash = "sha256-TPbz3WAPqoD/tJ3fB6g/jvvsM+OjVbuIwpo6dHjJwYM=";
  };

  npmDepsHash = "sha256-R+5ZBDSDZD7nR073EePOCumEwlUeXTiJhhcZ1qby5JA=";

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
