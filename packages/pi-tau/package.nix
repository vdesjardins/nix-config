{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage {
  pname = "pi-tau";
  version = "1.0.8";

  src = fetchFromGitHub {
    owner = "deflating";
    repo = "tau";
    rev = "fbee2f63e126d77fcae8fb5ea87cacd08b10ddf4";
    hash = "sha256-r1c6MtUImU9fqy5bwRlBV7dIv3ELDLO9o4SSynAKyPU=";
  };

  npmDepsHash = "sha256-LR1M+Q5sSJD6JhrC3I7W0TMbwinJe/v9+NZGKyz1pAk=";
  dontNpmBuild = true;

  # Fix upstream bug: /api/instances handler missing body and closing brace,
  # causing a syntax error that prevents jiti from loading the extension.
  # See: https://github.com/deflating/tau/blob/fbee2f63/extensions/mirror-server.ts#L930
  postPatch = ''
        substituteInPlace extensions/mirror-server.ts \
          --replace-fail \
            'if (urlPath === "/api/instances") {
    ' \
            'if (urlPath === "/api/instances") {
          res.writeHead(200, { "Content-Type": "application/json" });
          res.end(JSON.stringify(getRunningInstances()));
          return;
        }
    '
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out
    cp package.json $out/
    cp -r extensions public node_modules $out/
    runHook postInstall
  '';

  meta = with lib; {
    description = "Web UI that mirrors your Pi terminal session in the browser";
    homepage = "https://github.com/deflating/tau";
    license = licenses.mit;
  };
}
