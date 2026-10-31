{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  bun,
  esbuild,
}:
buildNpmPackage {
  pname = "opencode-notifier";
  version = "1.1.2-unstable-2026-11-01";

  nativeBuildInputs = [bun esbuild];

  src = fetchFromGitHub {
    owner = "mohak34";
    repo = "opencode-notifier";
    rev = "460bae5dbe1cd5e59f7123a16ec423c9bf67bbba";
    hash = "sha256-datk6EHmiXqAySumpyY4xlb+Zqu4csMxXRLlZCIhxNg=";
  };

  npmDepsHash = "sha256-uBBtUW1KWTZJ9n6SMs07A5oMqnF9yfoL+pE0IJ2tyWQ=";

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
