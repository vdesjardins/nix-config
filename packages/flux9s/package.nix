{
  fetchFromGitHub,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "flux9s";
  version = "1.5.1";

  src = fetchFromGitHub {
    owner = "dgunzy";
    repo = "flux9s";
    rev = "v${version}";
    hash = "sha256-Xt2J7qTyPDlL1Jhdr6N4OzeV2klcrgWLo7wMBYKvgdg=";
  };

  cargoHash = "sha256-mCfOSvYZsfVL29gDpiZIS7iZogCStz2xNnxeihoUeJM=";

  nativeBuildInputs = [pkg-config];
  buildInputs = [openssl];

  doCheck = false;

  meta = {
    description = "A K9s-inspired terminal UI for monitoring Flux GitOps resources";
    homepage = "https://github.com/dgunzy/flux9s";
    license = lib.licenses.asl20;
    platforms = lib.platforms.all;
    mainProgram = "flux9s";
  };
}
