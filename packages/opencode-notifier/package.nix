{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  bun,
  esbuild,
}:
buildNpmPackage {
  pname = "opencode-notifier";
  version = "1.2.0-unstable-2026-11-26";

  nativeBuildInputs = [bun esbuild];

  src = fetchFromGitHub {
    owner = "mohak34";
    repo = "opencode-notifier";
    rev = "69010573b118dd0732b105d0f6a43d671144f5ac";
    hash = "sha256-y64aH7BsfWHfRiZSGQWbTtuaeWQdPaVxlXdXvdlKVMc=";
  };

  npmDepsHash = "sha256-LTn9gbBDRjMrwI5tthSCWBxHRNSzDE1i2d77v7Ei/Ik=";

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
