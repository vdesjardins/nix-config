{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  bun,
  esbuild,
}:
buildNpmPackage {
  pname = "opencode-notifier";
  version = "0.2.8-unstable-2026-07-19";

  nativeBuildInputs = [bun esbuild];

  src = fetchFromGitHub {
    owner = "mohak34";
    repo = "opencode-notifier";
    rev = "4612b3ca5883c53e4de5891b9355fb947dc7cbfa";
    hash = "sha256-kZjm/hDV+u8hDX3a0MtYgRd95VmcfSvPSLaz8BHn45M=";
  };

  npmDepsHash = "sha256-79Vbj4Odu7gxjSrklKK3abGC9C13N9zb8qQyGISjCSw=";

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
