{
  fetchFromGitHub,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "flux9s";
  version = "1.3.0";

  src = fetchFromGitHub {
    owner = "dgunzy";
    repo = "flux9s";
    rev = "v${version}";
    hash = "sha256-atlPQsDkE/9esZC3feMe0o8j1RgkM4zF1W9H8GMB5DY=";
  };

  cargoHash = "sha256-j9ayJzqEURKmmhbpSnNAgeJM4PgEw0K07/hTNo64Teo=";

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
