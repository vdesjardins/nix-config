{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  bun,
  esbuild,
}:
buildNpmPackage {
  pname = "opencode-notifier";
  version = "0-unstable-2026-06-05";

  nativeBuildInputs = [bun esbuild];

  src = fetchFromGitHub {
    owner = "mohak34";
    repo = "opencode-notifier";
    rev = "509382c0cb03c5036d84ef873e84c8ba2d92d2d0";
    hash = "sha256-c9+RY0D0lyk2pjNZaWxS9KGBtHK7efUKyLcKYBDxBWc=";
  };

  npmDepsHash = "sha256-cvd4HOzkVwO6JmYYCjPQhgoZerWdyFNHiPBQiAmPf0Y=";

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
