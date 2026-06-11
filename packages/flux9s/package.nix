{
  fetchFromGitHub,
  lib,
  openssl,
  pkg-config,
  rustPlatform,
}:
rustPlatform.buildRustPackage rec {
  pname = "flux9s";
  version = "0.9.2";

  src = fetchFromGitHub {
    owner = "dgunzy";
    repo = "flux9s";
    rev = "v${version}";
    hash = "sha256-wZgOkLg3lEMyoq0J94Z8zESz59CVVwNE6CzI82YibuQ=";
  };

  cargoHash = "sha256-wblh37zQ9i62TobRwiH+9T1Fl4l5wErL03iBAibya0c=";

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
