{
  bun,
  lib,
  fetchFromGitHub,
  buildNpmPackage,
}:
buildNpmPackage rec {
  pname = "slackcli";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "shaharia-lab";
    repo = "slackcli";
    rev = "v${version}";
    sha256 = "sha256-/zzwGJlrozdrBl1rFUvsvNDmxY0xP70wjw1OqJE1oTU=";
  };

  npmDepsHash = "sha256-4WFL6zIfpjKpkRfwXg+9x6i5L9LafpQ+BSUsIYDl5t8=";

  packageLock = ./package-lock.json;

  nativeBuildInputs = [bun];

  postPatch = ''
    cp ${./package-lock.json} ./package-lock.json
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp ./dist/slackcli $out/bin/slackcli
    chmod +x $out/bin/slackcli
  '';

  meta = with lib; {
    description = "Fast CLI tool for interacting with Slack workspaces and channels";
    homepage = "https://github.com/shaharia-lab/slackcli";
    license = licenses.mit;
    mainProgram = "slackcli";
  };
}
