{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  bun,
  esbuild,
}:
buildNpmPackage {
  pname = "opencode-notifier";
  version = "0.1.30-unstable-2026-03-04";

  nativeBuildInputs = [bun esbuild];

  src = fetchFromGitHub {
    owner = "mohak34";
    repo = "opencode-notifier";
    rev = "4a7bd4c3b8f4e5c70962a53b1847ff4580cae8a8";
    hash = "sha256-zkJJo1sCnejdupdYVi6ryIn5b8eUof+eDoCbLvf4Feg=";
  };

  npmDepsHash = "sha256-7LUQ5xFxe+PMK92erZV6LYBq0PL7eyc+mytACVz3w5I=";

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
