{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  bun,
  esbuild,
}:
buildNpmPackage {
  pname = "opencode-notifier";
  version = "0-unstable-2026-05-14";

  nativeBuildInputs = [bun esbuild];

  src = fetchFromGitHub {
    owner = "mohak34";
    repo = "opencode-notifier";
    rev = "20ee6462253bfa2dca25befb0e605897c121e425";
    hash = "sha256-hL8QO0wR51m5P8vQ4F91Dk1y0cUhi3dd88cBVmwmDJo=";
  };

  npmDepsHash = "sha256-j0LnQZFcHqCndMCaRd95+IHigMASAfEaJkOddHgp7/I=";

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
