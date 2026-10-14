{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage {
  pname = "pi-tau";
  version = "0-unstable-2026-09-30";

  src = fetchFromGitHub {
    owner = "deflating";
    repo = "tau";
    rev = "f1bc1ac017f1e8bc60c70fea73797c1e29098b6f";
    hash = "sha256-WpXWQNgsNiYPGgTZq8vWFAqzmS5mIfi00WhSgBJWoXg=";
  };

  npmDepsHash = "sha256-CMDnzG1JbEkg7Eu59Ya0AQUCmR0gMArUV8GfDruXX0Y=";
  dontNpmBuild = true;

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
