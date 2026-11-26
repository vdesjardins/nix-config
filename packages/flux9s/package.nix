{
  fetchFromGitHub,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "flux9s";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "dgunzy";
    repo = "flux9s";
    rev = "v${version}";
    hash = "sha256-x/klXGQm6sLhLayv0B7spEt/m5N1p/hoP/Rm+jfx+YM=";
  };

  cargoHash = "sha256-3E3Y2cgVd5DcYc7UxOPpkREw6Gxhu8ayGUPibT/LeOs=";

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
