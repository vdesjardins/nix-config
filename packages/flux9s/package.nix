{
  fetchFromGitHub,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "flux9s";
  version = "1.0.4";

  src = fetchFromGitHub {
    owner = "dgunzy";
    repo = "flux9s";
    rev = "v${version}";
    hash = "sha256-xrOz0xHQ+BLO1l6seORByTOfXEnAJiqmFBX70OGX9K4=";
  };

  cargoHash = "sha256-GdzB0bHSbs7ZbrnB1SfsV2+4nA+UP6dxfPcNV6ysweY=";

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
